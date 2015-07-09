class User < ActiveRecord::Base

  attr_accessor :email
  attr_accessor :password

  has_one :login
  has_one :private_address, class_name: 'Address'
  has_one :work_address,    class_name: 'Address'

end
