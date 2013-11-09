class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy, :add_users, :update_to_add_users]
  before_filter :login_required

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases=current_user.purchases
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
    # Prevents unauthorized access by other users
    if !current_user.purchases.where(:id => @purchase.id).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
    @users= @purchase.users

    # Add user that has made it to the page
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
    # Prevents unauthorized access by other users
    if !current_user.purchases.where(:id => @purchase.id).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
    @payments = @purchase.payments
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)
        
    respond_to do |format|
      if @purchase.save
        payment = Payment.new()
        payment.user_id = current_user.id
        payment.purchase_id = @purchase.id
        payment.save

        for user_id in params[:purchase][:user_ids]
          if user_id != ""
            payment = Payment.new()
            payment.user_id = user_id
            payment.purchase_id = @purchase.id
            payment.save
          end
        end

        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render action: 'show', status: :created, location: @purchase }
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
    if !current_user.purchases.where(:id => @purchase.id).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
    respond_to do |format|
      if @purchase.update(purchase_params)
        @purchase.get_current_user_payment(current_user).update(:part => params[:user_parts])
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
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

  def add_users
  end

  # PATCH/PUT /purchases/1/add_user
  def update_to_add_users
    # Prevents unauthorized access by other users
    if !current_user.purchases.where(:id => @purchase.id).any?
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end
    respond_to do |format|
      for user_id in params[:purchase][:user_ids]
        if user_id != ""
          payment = Payment.new()
          payment.user_id = user_id
          payment.purchase_id = @purchase.id
          payment.save
        end
      end

      format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
      format.json { render action: 'show', status: :created, location: @purchase }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:title, :price, :user_ids)
    end
end
