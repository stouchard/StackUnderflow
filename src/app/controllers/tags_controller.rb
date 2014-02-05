# -*- coding: utf-8 -*-
class TagsController < ApplicationController
  
  def index
    @tags = Tag.all()
  end

  def show
    @tag= Tag.find(params[:id])
    @questions = @tag.questions
  end

  def edit
    @tag = Tag.find( params[:id] )
  end


  def new
    @tag = Tag.new()
  end

  def create
    puts(params[:tag])
    tag = Tag.new(params[:tag])
    if tag.save
      redirect_to tags_path, :notice => "Votre tag a bien ete ajoute"
    else
      render "new"
    end
  end
  
  def destroy
    tag = Tag.find( params[:id])
    if tag.destroy
      redirect_to tags_path, :notice => "Votre tag a bien eté supprimee"
    else
      redirect_to tags_path, :notice => "Votre tag n'a pas pu etre supprimee"
    end 
  end
  




end