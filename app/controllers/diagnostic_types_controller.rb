class DiagnosticTypesController < ApplicationController
  before_action :set_result, only: [:edit, :update]

  def index
    @results = DiagnosticType.all
  end

  def update
    if @result.update_attributes(result_params)
      flash.now[:success] = { title: 'Done',
                              text: 'Result was successfully updated.' }
    end
  end

  private
    def set_result
      @result = DiagnosticType.find_by(id: params[:id])
    end

    def result_params
      params.require(:diagnostic_type)
            .permit(:title, :description, :points_from, :points_to)
    end

end
