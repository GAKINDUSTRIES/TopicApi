# encoding: utf-8

class IconUploader < BaseUploader
  protected

  def extension_white_list
    %w( jpg )
  end
end
