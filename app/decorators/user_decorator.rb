class UserDecorator < Draper::Decorator
  delegate_all

  def f_name
    full_name.split(' ')[0]
  end

  def l_name
    full_name.split(' ')[1]
  end

end
