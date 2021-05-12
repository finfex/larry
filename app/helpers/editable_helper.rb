# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module EditableHelper
  def allow_edit_column?(record, column)
    return false if column.to_s == 'id'

    # Sometimes model has no attribute decorator has
    return false unless record.respond_to? column
    return false unless record.respond_to? column.to_s + '='

    value = record.send column
    return false if value.is_a? ActiveRecord::Associations::CollectionProxy

    return record.updatable_by? current_user if record.respond_to? :updatable_by?

    if record.respond_to? :parent
      return record.parent.updatable_by? current_user if record.parent.respond_to? :updatable_by?
    else
      true
    end

    true
  end
end
