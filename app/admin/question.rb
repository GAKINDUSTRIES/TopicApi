ActiveAdmin.register Question do
  index do
    selectable_column
    id_column
    column :email
    column :body

    actions
  end

  filter :email
  filter :body

  show do
    attributes_table do
      row :id
      row :email
      row :body
    end
  end
end
