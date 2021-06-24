# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# https://gist.githubusercontent.com/sj26/2026284/raw/1d943fcab35b83989a842e227b6652a7de186dee/uploader_input.rb
# A formtastic input which incorporates carrierwave uploader functionality.
#
# Intelligently adds the cache field, displays and links to the current
# value if there is one, adds a class to the wrapper when replacing an
# existing value, allows removing an existing value with the checkbox
# taking into account validation requirements.
#
# There are several options:
#
#  * Toggle the replacement field with `replaceable: true/false`.
#  * The replace file label is translatable as `replace_label` or using option `replace_label: "value"` (like `label`).
#  * Toggle the remove checkbox with `removable: true/false` (`true` overrides `required`).
#  * The remove checkbox label is translatable as `remove_label` or using option `remove_label: "value"` (like `label`).
#  * Override existing file display and links using `existing_html` and `existing_link_html` (like `wrapper_html`).
#
# Example: `form.input :file, as: "uploader"`
#
# Copyright (c) Samuel Cochran 2012, under the [MIT license](http://www.opensource.org/licenses/mit-license).

# rubocop:disable Metrics/ClassLength
class FileUploaderInput < Formtastic::Inputs::FileInput
  def linkable?
    options[:linkable] != false
  end

  def replaceable?
    options[:replaceable] != false
  end

  def removable?
    options[:removable] != false and (options[:removable] == true or !required?)
  end

  def method_present?
    if object.respond_to?("#{method}?")
      object.send("#{method}?")
    else
      object.send(method).present?
    end
  end

  def method_changed?
    if object.respond_to? "#{method}_changed?"
      object.send "#{method}_changed?"
    else
      false
    end
  end

  def method_was_present?
    if method_changed?
      object.send("#{method}_was").present?
    else
      method_present?
    end
  end

  def wrapper_html_options
    super.tap do |options|
      options[:class] << ' replaceable' if replaceable?
      options[:class] << ' removable' if removable?
      options[:class] << ' present' if method_present?
      options[:class] << ' changed' if method_changed?
      options[:class] << ' was_present' if method_was_present?
    end
  end

  def cache_html
    (builder.hidden_field("#{method}_cache") if method_changed?) or ''.html_safe
  end

  def file_html
    builder.file_field(method, input_html_options)
  end

  def existing_html_options
    expand_html_options(options[:existing_html]) do |opts|
      opts[:class] << 'existing'
    end
  end

  def existing_link_html_options
    expand_html_options(options[:existing_link_html]) do |opts|
      opts[:class] << 'existing'
    end
  end

  def uploader
    object.send(method).class
  end

  def versions
    uploader.versions.keys
  end

  def file_version(version)
    version ? object.send(method).send(version) : object.send(method)
  end

  def existing_html
    if method_present?
      # TODO: Add classes based on mime type for icons, etc.
      existing = template.content_tag(:span, object.send(method).file.filename, existing_html_options)
      version = versions.first
      image = file_version versions.first
      title = "#{version} [#{image.size}]"
      buffer = template.image_tag(image.url, title: title, alt: title)
      buffer << template.link_to_if(linkable?, existing, object.send(method).url, existing_link_html_options)
      buffer
    end or ''.html_safe
  end

  def replace_label_html
    template.content_tag(:label, class: 'replace_label') do
      template.content_tag(:span, localized_string(method, "Replace #{method.to_s.titleize}", :replace_label))
    end
  end

  def replace_html
    if replaceable?
      replace_label_html <<
        file_html
    end or ''.html_safe
  end

  def remove_html
    if removable?
      template.content_tag(:label, class: 'remove_label') do
        template.check_box_tag("#{object_name}[remove_#{method}]", '1', false, id: "#{sanitized_object_name}_remove_#{sanitized_method_name}") <<
          # XXX: There are probably better ways to do these translations using defaults.
          template.content_tag(:span, localized_string(method, "Remove #{method.to_s.titleize}", :remove_label))
      end
    end or ''.html_safe
  end

  def to_html
    input_wrapping do
      label_html <<
        cache_html <<
        if method_was_present?
          existing_html <<
          replace_html <<
          remove_html
        else
          existing_html <<
          file_html
        end
    end
  end

  protected

  # rubocop:disable Metrics/MethodLength
  def expand_html_options(opts)
    (opts || {}).dup.tap do |local_opts|
      local_opts[:class] =
        case local_opts[:class]
        when Array
          local_opts[:class].dup
        when nil
          []
        else
          [local_opts[:class].to_s]
        end
      local_opts[:data] =
        case local_opts[:data]
        when Hash
          local_opts[:data].dup
        when nil
          {}
        else
          { '' => local_opts[:data].to_s }
        end

      yield local_opts if block_given?

      local_opts[:class] = local_opts[:class].join(' ')
    end
  end
end
# rubocop:enable Metrics/MethodLength

# class FileUploaderInput < Formtastic::Inputs::FileInput

# def method_present?
# if object.respond_to?("#{method}?")
# object.send("#{method}?")
# else
# object.send(method).present?
# end
# end

# def file?
# object.send("#{method}?")
# end

# def file_html
# builder.file_field(method, input_html_options)
# end

# def remove_label_html
# template.content_tag(:label, class: 'remove_label') do
# template.content_tag(:span, localized_string(method, "Удалить #{method.to_s.titleize}", :remove_label))
# end
# end

# def versions_label_html
# template.content_tag(:label) do
# template.content_tag(:span, localized_string(method, "Версии", :versions))
# end
# end

# def uploader
# object.send(method).class
# end

# def versions
# uploader.versions.keys
# end

# def versions_html
# versions.map do |version|
# image = file_version version
# title = "#{version} [#{image.size}]"
# template.content_tag :span do

# template.image_tag( image.url, :title => title, :alt => title )

# end
# end.join(' ').html_safe
# end

# def file_version version
# object.send(method).send(version) || object.send(method)
# end

# def remove_html
# template.content_tag(:label, class: "remove_label") do
# template.check_box_tag("#{object_name}[_destroy]", "1", false, id: "#{sanitized_object_name}_remove_#{sanitized_method_name}")
# end.html_safe
# end

# def existing_html
# if method_present?
# existing = template.content_tag(:span, object.send(method).file.filename)
# template.link_to existing, object.send(method).url, {:target=>'_blank'}
# end or "".html_safe
# end

# def to_html
# input_wrapping do
# label_html << file_html << existing_html
# end <<

# if file? and versions.any?
# input_wrapping do
# versions_label_html << versions_html
# end
# end <<

# if file?
# input_wrapping do
# remove_label_html << remove_html
# end
# end or ''.html_safe
# end
# end
