module API
  module V1
    class StatesController < ApplicationController

      # DUE TO READ-ONLY FILEMOUNT WITH HEROKU SERVER, PAGE CACHING NOT
      #  AVAILABLE IN PRODUCTION
      # Not caching :show due to issue with varying filenames that need
      #  to be cleared, and lack of wildcard with page cache gem
      # caches_page :index
      
      # Render all States and gas prices. States are selected from a scope
      #  that only selects States updated in the last 24 hours. If there are
      #  no States, or all States havent been updated today, then an update
      #  routine loads the States and their gas price info into the db.
      # Page caching stores this controller's response in a local file. This
      #  is expired anytime the States are out of selection scope.
      def index
        states = State.today

        if states.blank? || states.count < 50
          update_gas_records
          # expire_page action: 'index'
          states = State.today
        end

        # calculating cache values
        last_update    = states.maximum(:updated_at).to_datetime
        next_update    = last_update + 1
        will_expire_in = next_update.to_time - Time.now

        # caching headers
        expires_in will_expire_in.to_i, :public => true
        response.headers['Last-Modified'] = last_update.utc.to_s
        response.headers['Expires']       = next_update.utc.to_s

        render json: states, status: 200
      end

      # Render a single State and its gas price. If an invalid State name is
      #  input, a HTTP Status 422 is returned.
      def show
        state_name_param = get_state_name(params[:name])
        state            = State.find_by(name: state_name_param)

        if !state.blank?
          # calculating cache values
          last_update    = state.updated_at.to_datetime
          next_update    = last_update + 1
          will_expire_in = next_update.to_time - Time.now

          # cache headers
          expires_in will_expire_in.to_i, :public => true
          response.headers['Last-Modified'] = last_update.utc.to_s
          response.headers['Expires']       = next_update.utc.to_s
          render json: state, status: 200
        else
          expires_in 1.hour, :public => true
          render json: {'error' => 'invalid argument'}, status: 422 # invalid payload
        end
      end

      private

      # Scrapes fuelgaugereport.aaa.com for today's gas price data, and creates
      #  a State record for each if not exists, else updates existing State
      #  record.
      # @return VOID
      def update_gas_records
        mechanize = Mechanize.new

        page  = mechanize.get('http://fuelgaugereport.aaa.com/import/display.php?lt=state')
        table = page.at('table#states')

        table.xpath("//tbody/tr").collect do |row|
          name  = get_state_name(row.at('td[1]').at('a').text.strip)
          price = row.at('td[2]').text.strip

          state = State.find_by(name: name)

          # Create or Update
          if state.blank?
            state = State.new({ name: name, price: price })
            state.save
          else
            state.update({ price: price, :updated_at => Time.now })
          end
        end
      end

      # Converts the full text state name into the two-character postal
      #  abbreviation for a US state. If the name was already entered as a two 
      #  character abbreviation, it will be capitalized. 
      # @see StatesAbbrvHelper
      # @param String state_name
      # @return String
      def get_state_name(state_name)
        # Storing hash of US states / abbreviations here for now to simplify 
        #  conversion process, and reduce load on DB. Can be abstracted into
        #  a helper or module if needed elsewhere.
        us_states_abbrv = {
          "Alabama"        => "AL",
          "Alaska"         => "AK",
          "Arizona"        => "AZ",
          "Arkansas"       => "AR",
          "California"     => "CA",
          "Colorado"       => "CO",
          "Connecticut"    => "CT",
          "Delaware"       => "DE",
          "Florida"        => "FL",
          "Georgia"        => "GA",
          "Hawaii"         => "HI",
          "Idaho"          => "ID",
          "Illinois"       => "IL",
          "Indiana"        => "IN",
          "Iowa"           => "IA",
          "Kansas"         => "KS",
          "Kentucky"       => "KY",
          "Louisiana"      => "LA",
          "Maine"          => "ME",
          "Maryland"       => "MD",
          "Massachusetts"  => "MA",
          "Michigan"       => "MI",
          "Minnesota"      => "MN",
          "Mississippi"    => "MS",
          "Missouri"       => "MO",
          "Montana"        => "MT",
          "Nebraska"       => "NE",
          "Nevada"         => "NV",
          "New Hampshire"  => "NH",
          "New Jersey"     => "NJ",
          "New Mexico"     => "NM",
          "New York"       => "NY",
          "North Carolina" => "NC",
          "North Dakota"   => "ND",
          "Ohio"           => "OH",
          "Oklahoma"       => "OK",
          "Oregon"         => "OR",
          "Pennsylvania"   => "PA",
          "Rhode Island"   => "RI",
          "South Carolina" => "SC",
          "South Dakota"   => "SD",
          "Tennessee"      => "TN",
          "Texas"          => "TX",
          "Utah"           => "UT",
          "Vermont"        => "VT",
          "Virginia"       => "VA",
          "Washington"     => "WA",
          "West Virginia"  => "WV",
          "Wisconsin"      => "WI",
          "Wyoming"        => "WY"
        }

        if state_name.length > 2
          state_name = state_name.titleize
          state_name = us_states_abbrv[state_name]
        else
          state_name.upcase!
        end
        state_name
      end

    end
  end
end
