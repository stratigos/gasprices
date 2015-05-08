module API
  module V1
    class StatesController < ApplicationController
      
      # Render all States and gas prices
      def index
        states = State.all

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
