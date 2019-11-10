class Aspect < ApplicationRecord
  has_one :void, dependent: :destroy
end
