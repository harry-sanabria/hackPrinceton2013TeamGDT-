class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy, :add_users, :update_to_add_users]
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
    @purchase.current_total_price = 0
    @purchase.user_id = current_user.id

    respond_to do |format|
      if @purchase.save
        #puts "asgl;adskhfl;khgalds;khfsda;HIHIHIHIHIHIHIHIHI"
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

  # PATCH/PUT /purchases/1/join_purchase
  def join_purchase
    # Prevents unauthorized access by other users
    # if !current_user.purchases.where(:id => @purchase.id).any?
    #   flash[:notice] = "You don't have permission to view that page!"
    #   redirect_to current_user
    #   return
    # end
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      payment = Payment.new()
      payment.purchase_id = params[:id]
      payment.user_id = current_user.id
      payment.price = params[:price]
      payment.description = params[:description]
      payment.save

      # update current total price for this payment
      @purchase.update_current_total_price(payment)

      format.html { redirect_to @purchase, notice: 'Successfully joined purchase!' }
      format.json { render action: 'show', status: :created, location: @purchase }
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:title, :min_price, :group, :description, :deadline)
    end
end
