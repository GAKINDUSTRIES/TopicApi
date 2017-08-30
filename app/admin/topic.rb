ActiveAdmin.register Topic do
  permit_params :label, :icon

  form do |f|
    f.inputs 'Details' do
      f.input :label
      f.input :icon
    end

    actions
  end

  index do
    selectable_column
    id_column
    column :label

    actions
  end

  show do
    attributes_table do
      row :label
      row :icon do
        image_tag topic.icon.url if topic.icon?
      end
    end
  end
end
