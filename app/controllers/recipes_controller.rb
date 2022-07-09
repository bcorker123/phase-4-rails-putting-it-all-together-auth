class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :not_authorized

    def index 
        if session[:user_id]
            recipes = Recipe.all 
            render json: recipes
        else
            render json: {errors:["Not logged in"]}, status: :unauthorized
        end
    end 

    def create 
        if session[:user_id]
            recipe = Recipe.new(recipe_params)
            recipe[:user_id] = session[:user_id]
            recipe.save!
            render json: recipe, status: :created
        else
            render json: {errors:["Not logged in"]}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def not_authorized(exception)
        render json: {errors:[exception.record.errors.full_messages]}, status: :unprocessable_entity
    end
end
