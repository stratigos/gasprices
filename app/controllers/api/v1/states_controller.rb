module Api
  module V1
    class StatesController < ApplicationController
      def index
        states = State.all

        render json: states, status: 200
      end

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
