# coding: utf-8 

class AnswersController < ApplicationController
	before_filter :signed_in_user, only: [:create, :new, :edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update, :destroy]


	# Before filter
	def correct_user
		@answer = Answer.find( params[:id] )
		if @answer.user != current_user
			redirect_to @answer.question, :notice => "Vous ne pouvez modifier que vos propres reponses"
		end
	end


	def index
		@answers = Answer.all()
	end

	def show
          @answer = Answer.find(params[:id])
          @point = @answer.votes_for
        end

	def edit
		@answer = Answer.find( params[:id] )

	end


	def new
		@answer = Answer.new()
		@question = Question.find(params[:question_id])
		@answer.question_id = (params[:question_id])
	end

	def update
		oldanswer = Answer.find(params[:id])
		if oldanswer.update_attributes(params[:answer])
			redirect_to question_path(oldanswer.question), :notice => "Votre reponse a ete editee avec succes"
		else
			redirect_to question_path(oldanswer.question), :notice => "Votre reponse n'a pas pu etre editee"
		end  
		
	end

	def create
		puts("create params hash : " )
		puts(params[:answer])
		answer = Answer.new(params[:answer])
		answer.user = current_user
		if answer.save
			redirect_to question_path(answer.question), :notice => "Votre reponse a bien ete ajoutee"
		else
			render "new"
		end
	end

	def destroy
		answer = Answer.find( params[:id])
		if answer.destroy
			redirect_to question_path(answer.question), :notice => "Votre reponse a bien ete supprimee"
		else
			redirect_to question_path(answer.question), :notice => "Votre reponse n'a pas pu etre supprimee"
		end 
	end

        def vote_for
           logger.info "***vote for***!!!"
           logger.info params[:id]
           @answ_vote_for = Answer.find(params[:id])
           logger.info "***current user id***!!!"
           logger.info current_user.login
           
           if(current_user.id != @answ_vote_for.user.id)
             if current_user.voted_against?(@answ_vote_for)
               current_user.unvote_for(@answ_vote_for)
             else 
               current_user.vote_exclusively_for(@answ_vote_for)
             end
             
             positive_vote_count = @answ_vote_for.votes_for
             negative_vote_count = @answ_vote_for.votes_against
             logger.info current_user.voted_for?(@answ_vote_for)       
             @total_vote =positive_vote_count-negative_vote_count
             @answer_id = @answ_vote_for.id
             logger.info "calcul vote for"
             logger.info positive_vote_count-negative_vote_count
             respond_to do |format|
               format.js
               format.html
            end
             
           else
             positive_vote_count = @answ_vote_for.votes_for
             negative_vote_count = @answ_vote_for.votes_against
             logger.info current_user.voted_for?(@answ_vote_for)       
             @total_vote =positive_vote_count-negative_vote_count
             @answer_id = @answ_vote_for.id
             logger.info "calcul vote for"
             logger.info positive_vote_count-negative_vote_count
             respond_to do |format|
               format.js
               format.html
            end
             
           end
        end
         
         def vote_against
           logger.info "***vote against*!!!"
           logger.info params[:id]
           @answ_vote_against = Answer.find(params[:id])
             logger.info @answ_vote_against
           if(current_user.id != @answ_vote_against.user.id)
             if current_user.voted_for?(@answ_vote_against)
               current_user.unvote_for(@answ_vote_against)
             else 
               current_user.vote_exclusively_against(@answ_vote_against)
             end

             positive_vote_count = @answ_vote_against.votes_for
             negative_vote_count = @answ_vote_against.votes_against
             logger.info current_user.voted_for?(@answ_vote_against)               
             @total_vote =positive_vote_count-negative_vote_count
             @answer_id = @answ_vote_against.id
             logger.info "calcul vote against"
             logger.info positive_vote_count-negative_vote_count
             respond_to do |format|
               format.js
               format.html
             end
             
           else
             positive_vote_count = @answ_vote_against.votes_for
             negative_vote_count = @answ_vote_against.votes_against
             logger.info current_user.voted_for?(@answ_vote_against)               
             @total_vote =positive_vote_count-negative_vote_count
             @answer_id = @answ_vote_against.id
             logger.info "calcul vote against"
             logger.info positive_vote_count-negative_vote_count
             respond_to do |format|
               format.js
               format.html
             end
           end
         end
end
