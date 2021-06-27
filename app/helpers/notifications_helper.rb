module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    your_post = link_to t('notice.yourpost'), post_path(notification), style: 'font-weight: bold;'
    # notification.actionがfollowかfavか
    case notification.action
    when 'follow'
      tag.a(notification.visiter.name, href: user_path(@visiter), style: 'font-weight: bold;') + t('notice.followed')
    when 'fav'
      tag.a(notification.visiter.name, href: user_path(@visiter),
                                       style: 'font-weight: bold;') + t('notice.liked') + tag.a(t('notice.yourpost'), href: post_path(notification.post_id),
                                                                                                                      style: 'font-weight: bold;') + t('notice.good')
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
