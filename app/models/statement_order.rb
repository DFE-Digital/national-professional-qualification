class StatementOrder < ApplicationRecord
  belongs_to :statement
  belongs_to :order
end