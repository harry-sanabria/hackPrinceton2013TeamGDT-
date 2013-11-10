class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy, :add_users, :update_to_add_users, :close, :finalize, :submit_finalize]
  before_filter :login_required
  before_filter :venmo_required

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases=current_user.purchases
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
    # Prevents unauthorized access by other users
    # if !current_user.purchases.where(:id => @purchase.id).any?
    #   flash[:notice] = "You don't have permission to view that page!"
    #   redirect_to current_user
    #   return
    # end

  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
    # Prevents unauthorized access by other users
    if !current_user.purchases.where(:id => params[:id]).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
  end
  
  def edit_payment
    # Prevents unauthorized access by other users
    if !current_user.payments.where(:purchase_id => params[:id]).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
    @purchase = Purchase.find_by_id(params[:id])
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.state = 1
    @purchase.current_total_price = 0
    @purchase.user_id = current_user.id
    @purchase.group = params[:group_select]

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to purchase_confirm_post_path(@purchase), notice: 'Purchase was successfully created.' }
        format.json { render action: 'facebook_post_confirmed', status: :created, location: @purchase }
      else
        format.html { render action: 'new' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    # Prevents unauthorized access by other users
    if !current_user.payments.where(:purchase_id => @purchase.id).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
    respond_to do |format|
      if @purchase.update(purchase_params)
        # update current total price for this payment
        @purchase.update_current_total_price()

        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_payment
    # Prevents unauthorized access by other users
    if !current_user.payments.where(:purchase_id => params[:id]).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
    @purchase = Purchase.find_by_id(params[:id])
    respond_to do |format|
      if @purchase.get_current_user_payment(current_user).update(
          :price => params[:payment_price],
          :description => params[:payment_description])
        # update current total price for this payment
        @purchase.update_current_total_price()

        format.html { redirect_to @purchase, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_payment' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    # Prevents unauthorized access by other users
    if !current_user.purchases.where(:id => @purchase.id).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /purchases/1/join_purchase
  def join_purchase
    # Prevents unauthorized access by other users
    # if !current_user.purchases.where(:id => @purchase.id).any?
    #   flash[:notice] = "You don't have permission to view that page!"
    #   redirect_to current_user
    #   return
    # end
    @purchase = Purchase.find_by_id(params[:id])

    respond_to do |format|
      payment = Payment.new()
      payment.purchase_id = params[:id]
      payment.user_id = current_user.id
      payment.price = params[:price]
      payment.description = params[:description]
      saved = payment.save

      # update current total price for this payment
      @purchase.update_current_total_price()
      if saved
        format.html { redirect_to @purchase, notice: 'Successfully joined purchase!' }
        format.json { render action: 'show', status: :created, location: @purchase }
      else
        format.html { redirect_to @purchase, notice: 'Unable to join, please try again.' }
        format.json { render action: 'show', status: :created, location: @purchase }
      end
     end
  end

  def facebook_post_confirm
    @purchase = Purchase.find(params[:id])
  end
  
  def close
    #set state to closed
    @purchase.state = 3
    if @purchase.save
      respond_to do |format|
        format.html { redirect_to @purchase, notice: 'Closed purchase.' }
        format.json { render action: 'show', status: :created, location: @purchase }
      end
    end
  end

  def finalize
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:title, :min_price, :description, :deadline)
    end
end
