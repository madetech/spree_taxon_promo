module Spree
  class Calculator::FlatRateExcludeTaxonTotal < Calculator
    preference :amount, :decimal, :default => 0
    preference :currency, :string, :default => Spree::Config[:currency]
    preference :taxon, :string, :default => ''

    attr_accessible :preferred_amount, :preferred_currency, :preferred_taxon

    def self.description
      I18n.t(:flat_rate_exclude_taxon)
    end

    def compute(object)
      return unless object.present? and object.line_items.present?

      item_total = matched_products_total(object)

      if item_total > preferred_amount
        return item_total
      else
        return preferred_amount
      end
    end

    def matched_products_total(object)
      item_total = 0.0

      object.line_items.each do |line_item|
        item_total += line_item.amount if line_item.product.taxons.where(:name => preferred_taxon).blank?
      end

      item_total
    end
  end
end
