class TraderController < ApplicationController
    before_action :verify_approved
    def index
        if current_user.approved?
            render 'trader/index'
        else
            render 'pending'
        end
    end

    private

    def verify_approved
        redirect_to pending_path unless current_user.approved?
    end
end