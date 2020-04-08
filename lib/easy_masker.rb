module EasyMasker
  def self.included(target)
    target.extend(ClassMethods)
  end

  module ClassMethods
    def mask_attrs(*f)
      f.each do |f|
        define_method "masked_#{f.to_s}" do
          masked_text(send(f), :email)
        end
      end
    end
  end

  def masked_text(text, type = nil)
    return text if text.length < 3

    if type == :email
      pre_at = text.split('@').first
      pre_at = masked_text(pre_at)
      post_at = text.split('@').last
      post_at_domains = post_at.split('.')
      post_at_domains = post_at_domains.map { |p| masked_text(p) }
      post_at_domains = post_at_domains.join('.')
      pre_at + '@' + post_at_domains
    else
      text[0] + '*' * (text[1...-1].length) + text[-1]
    end
  end
end
