class Invitations < Application
  def new
    only_provides :html
    @invitation = Invitation.new(params[:invitation])
    @secondary_title = 'Invite your friends!'
    render
  end

  def create
    @invitation = Invitation.new(params[:invitation])
    if @invitation.save
      m = Merb::Mailer.new :to => @invitation.recipient,
                           :from => 'invitations@penguincoder.org',
                           :subject => 'TuxBliki Invitation!',
                           :body => partial('invitation', :format => 'text')
      m.deliver!
      flash[:notice] = "You just sent an invitation!"
      redirect url(:authors)
    else
      @secondary_title = 'Invite your friends!'
      render :new
    end
  end
end
