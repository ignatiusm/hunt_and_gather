class CreateConsultations < ActiveRecord::Migration[5.2]
  def change
    create_table :consultations do |t|
      t.text :department
      t.text :title
      t.date :closing_date
      t.text :about
      t.text :url

      t.timestamps
    end
  end
end
