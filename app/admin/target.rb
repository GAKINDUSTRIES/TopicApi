ActiveAdmin.register Target do
  target_attrs = %i(title lat lng radius user topic)
  permit_params :title, :lat, :lng, :radius, :user_id, :topic_id

  form do |f|
    f.inputs 'Details' do
      target_attrs.each { |attr| f.input attr }
    end

    actions
  end

  index do
    selectable_column
    id_column
    %i(title topic user).each { |col| column col }

    actions
  end

  show do
    attributes_table do
      target_attrs.each { |attr| row attr }
    end
  end
end
