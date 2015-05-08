module API
  module V1
    class StatesController < ApplicationController

      # render all States and gas prices
      def index
        states = State.all

        render json: states, status: 200
      end

      # render a single State and its gas price
      def show
        state = State.find(params[:id])

        render json: state, status: 200
      end

      # private
      # def state_params
      #   params.require(:state).permit(:name)
      # end
    end
  end
end
