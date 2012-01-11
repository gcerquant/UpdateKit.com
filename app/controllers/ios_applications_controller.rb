# iOS applications controller

require 'hpricot'
require 'open-uri'


class IosApplicationsController < ApplicationController
  
  
  load_and_authorize_resource
  
  before_filter :authenticate_user!,
       :only => [:protect_application, :unprotect_application]
      
      
      
  # GET /ios_applications
  # GET /ios_applications.json
  def index
    @ios_applications = IosApplication.search(params[:search])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ios_applications }
    end
  end

  # GET /ios_applications/1
  # GET /ios_applications/1.json
  def show
    
    @ios_application = IosApplication.find(params[:id]) if (params[:id])
    @ios_application = IosApplication.find_by_application_bundle_identifier(params[:bundle_identifier]) if @ios_application.nil? && params[:bundle_identifier]

    
    
    if @ios_application.nil?
      redirect_to new_ios_application_path(:bundle_identifier => params[:bundle_identifier] ), :notice => "No iOS application found for #{params[:bundle_identifier]}. Would you like to create it?"
       return
    end
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @ios_application }
    end
  end

  # GET /ios_applications/new
  # GET /ios_applications/new.json
  def new
    @ios_application = IosApplication.new


    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @ios_application }
    end
  end

  # GET /ios_applications/1/edit
  def edit
    # @ios_application = IosApplication.find(params[:id])
    # 
    # authorize! :update, @ios_application
  end

  # POST /ios_applications
  # POST /ios_applications.json
  def create
    @ios_application = IosApplication.new(params[:ios_application])

    respond_to do |format|
      if @ios_application.save
        format.html { redirect_to @ios_application, :notice => 'iOS application #{ios_application.title} was successfully created.' }
        format.json { render :json => @ios_application, :status => :created, :location => @ios_application }
      else
        format.html { render :action => "new" }
        format.json { render :json => @ios_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ios_applications/1
  # PUT /ios_applications/1.json
  def update
    @ios_application = IosApplication.find(params[:id])

    respond_to do |format|
      if @ios_application.update_attributes(params[:ios_application])
        format.html { redirect_to @ios_application, :notice => 'Ios application was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @ios_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ios_applications/1
  # DELETE /ios_applications/1.json
  def destroy
    @ios_application = IosApplication.find(params[:id])
    @ios_application.destroy

    respond_to do |format|
      format.html { redirect_to ios_applications_url }
      format.json { head :ok }
    end
  end
  
  
  def update_info # refactor this name (it is not the action of updating, but get_update_info)
    @ios_application = IosApplication.find_by_application_bundle_identifier(params[:bundle_identifier])
    
    if @ios_application
      # todo : only return new_version_number key if it is relevant (ie, there is an update)
      # same for appleID
      render :json => {"update_is_available" => @ios_application.published_version_number != params[:version_number], "new_version_number" => @ios_application.published_version_number, "appleID" => @ios_application.apple_identifier, "update_url" => @ios_application.update_url }
    else
      render :json => { "error" => "No application found for identifier #{params[:bundle_identifier]}. Go to #{ios_application_register_bundle_identifier_url} to create it." }
    end
    
  end
  
  
  
  def fetch_version_number
    @ios_application = IosApplication.find(params[:id])
    
    result = @ios_application.fetch_version_number_from_apple_server
    redirect_to @ios_application, result
    
  end
  
  
  # Only the user associated with it can edit it later on
  def protect_application
    @ios_application = IosApplication.find(params[:id])

    if (@ios_application.owner == current_user || ! @ios_application.protected_by_owner? ) # security check
      # No current owner, or I am the owner
      @ios_application.user = current_user
      if @ios_application.save
        redirect_to @ios_application, :notice => "This application is now protected. Only you can edit it."
      else
        redirect_to @ios_application, :alert => "Failed to protect this application."
      end
    else
      puts "This should not be possible"
      redirect_to @ios_application, :alert => "Someone else owns this application"
    end
  end

  def unprotect_application
    @ios_application = IosApplication.find(params[:id])
    
    if ((! @ios_application.owner.nil? ) && @ios_application.owner == current_user)
      
      @ios_application.user = nil      
      if @ios_application.save
        redirect_to @ios_application, :notice => "This application is now unprotected. Everyone can edit it and protect it."
      else
        redirect_to @ios_application, :alert => "Failed to protect this application."
      end
    else
      puts "This should not be possible"
      redirect_to @ios_application, :alert => "Someone else owns this application"
    end
    
  end
  
end
