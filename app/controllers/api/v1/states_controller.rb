module API
  module V1
    class StatesController < ApplicationController
      
      # Render all States and gas prices
      def index
        states = State.today

        if states.blank? || states.count < 50
          update_gas_records
          states = State.today
        end

        render json: states, status: 200
      end

      # Render a single State and its gas price
      def show
        state_name_param = get_state_name(params[:name])
        state            = State.find_by(name: state_name_param)

        if !state.blank?
          render json: state, status: 200
        else
          render json: {'error' => 'invalid argument'}, status: 422 # invalid payload
        end
      end

      private

      # Scrapes fuelgaugereport.aaa.com for today's gas price data, and creates
      #  a State record for each if not exists, else updates existing State
      #  record.
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
