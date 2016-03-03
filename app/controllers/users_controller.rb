class UsersController < ApplicationController
  before_filter :skip_first_page, :only => :new
  
  def new
    #binding.pry
    # if params[:ref] == '1de239iu123'
    #     redirect_to '/refer-a-friend'
    # end
    @bodyId = 'home'
    @is_mobile = mobile_device?        

    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    # Get user to see if they have already signed up
    @user = User.find_by_email(params[:user][:email]);
    # If user doesnt exist, make them, and attach referrer
    if @user.nil?
      cur_ip = IpAddress.find_by_address(request.env['HTTP_X_FORWARDED_FOR'])

      if !cur_ip
        cur_ip = IpAddress.create(
          :address => request.env['HTTP_X_FORWARDED_FOR'],
          :count => 0
        )
      end
      
      if cur_ip.count > 1
        return redirect_to root_path, :alert => "You tried to sign up twice with same ip address."
      else
        cur_ip.count = cur_ip.count + 1
        cur_ip.save
      end

      referred_by = User.find_by_referral_code(params[:ref])
      
      if referred_by
        referred_by.referral_registered_number += 1
        referred_by.save
      end

      role = params[:commit] == "REGISTER AS INSTRUCTOR" ? "instructor" : "student"
      @user = User.new(:email => params[:user][:email], :role => role)

      if referred_by.present?
        @user.referrer = referred_by
      end

      @user.save
    end

    session[:user_id] = @user.id

    # Send them over refer action
    respond_to do |format|
        if !@user.nil?
            cookies[:h_email] = { :value => @user.email }
            if (@user.role == "instructor") 
                format.html { redirect_to '/refer-a-instructor' }
            else 
                format.html { redirect_to '/refer-a-student' }
            end
        else
            format.html { redirect_to root_path, :alert => "Something went wrong!" }
        end
    end
  end

  def refer_student
      email = cookies[:h_email]

      @bodyId = 'refer-student'
      @is_mobile = mobile_device?

      @user = User.find_by_email(email)

      respond_to do |format|
          if !@user.nil?
              format.html #refer_student.html.erb
          else
              format.html { redirect_to root_path, :alert => "Something went wrong!" }
          end
      end
  end

  def refer_instructor
      email = cookies[:h_email]

      @bodyId = 'refer-instructor'
      @is_mobile = mobile_device?

      @user = User.find_by_email(email)

      respond_to do |format|
          if !@user.nil?
              format.html #refer_instructor.html.erb
          else
              format.html { redirect_to root_path, :alert => "Something went wrong!" }
          end
      end
  end

    
  def redirect
      redirect_to root_path, :status => 404
  end

  private 

  def skip_first_page
      if !Rails.application.config.ended
          email = cookies[:h_email]
          if email and !(user = User.find_by_email(email)).nil?
              if (user.role == "instructor")
                  redirect_to '/refer-a-instructor'
              else 
                  redirect_to '/refer-a-student'
              end
          else
              cookies.delete :h_email
          end
      end
  end

end
