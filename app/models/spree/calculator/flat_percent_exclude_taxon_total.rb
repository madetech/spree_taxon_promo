module Spree
  class Calculator::FlatPercentExcludeTaxonTotal < Spree::Calculator::FlatPercentTaxonTotal
    def self.description
      I18n.t(:flat_percent_exclude_taxon)
    end

    def compute(object)
      return unless object.present? and object.line_items.present?

      item_total = 0.0
      object.line_items.each do |line_item|
        item_total += line_item.amount if line_item.product.taxons.where(:name => preferred_taxon).blank?
      end
      value = item_total * BigDecimal(self.preferred_flat_percent.to_s) / 100.0
      (value * 100).round.to_f / 100
    end
  end
end
