class DiagnosticQuestionsController < ApplicationController
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = DiagnosticQuestion.includes(:answers).all
  end

  def new
    @question = DiagnosticQuestion.new
    5.times { @question.answers.build }
  end

  def create
    @question = DiagnosticQuestion.new(question_params)

    if @question.save
      flash.now[:success] = { title: 'Done',
                             text: 'Question has been added.' }
    end
  end

  def edit
  end

  def update
    if @question.update_attributes(question_params)
      flash.now[:success] = { title: 'Done',
                              text: 'Question successfully updated.' }
    end
  end

  def destroy
    if @question && @question.destroy
      flash.now[:success] = { title: 'Done',
                              text: 'Question has been deleted.' }
    else
      flash.now[:error] = { title: 'Error',
                            text: 'Question has not been deleted.' }
    end
  end

  private
    def question_params
      params.require(:diagnostic_question)
            .permit(:question_text, :insight_group_id, answers_attributes: [ :id, :answer_text,
                                                          :number_points ])
    end

    def set_question
      @question = DiagnosticQuestion.find_by(id: params[:id])
    end
end
