class DeliveriesController < ApplicationController
  def index

    # if there is no user in the cookie, then redirects to the login page
    if current_user == nil
      redirect_to("/users/sign_in")

    # else if there is user in the cookie then render the index page of deliveries 
    else
      matching_deliveries = Delivery.all

      @list_of_deliveries = matching_deliveries.order({ :created_at => :desc })

      render({ :template => "deliveries/index" })
    end
  end

  def show
    the_id = params.fetch("path_id")

    matching_deliveries = Delivery.where({ :id => the_id })

    @the_delivery = matching_deliveries.at(0)

    render({ :template => "deliveries/show" })
  end

  def create
    the_delivery = Delivery.new
    the_delivery.user_id = current_user.id
    the_delivery.description = params.fetch("query_description")
    the_delivery.details = params.fetch("query_details")
    the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    the_delivery.arrived = false

    if the_delivery.valid?
      the_delivery.save
      redirect_to("/deliveries", { :notice => "Added to list." })
    else
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)

    # the_delivery.user_id = current_user.id
    # the_delivery.description = params.fetch("query_description")
    # the_delivery.details = params.fetch("query_details")
    # the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    the_delivery.arrived = params.fetch("query_arrived")

    if the_delivery.valid?
      the_delivery.save
      # redirect_to("/deliveries/#{the_delivery.id}", { :notice => "Delivery updated successfully."} )
      redirect_to("/", { :notice => "Marked as received."} )
    else
      # redirect_to("/deliveries/#{the_delivery.id}", { :alert => the_delivery.errors.full_messages.to_sentence })
      redirect_to("/", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)

    the_delivery.destroy

    redirect_to("/deliveries", { :notice => "Deleted."} )
  end
end
