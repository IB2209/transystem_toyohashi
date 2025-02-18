# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_18_070450) do
  create_table "daily_reports", force: :cascade do |t|
    t.date "work_date"
    t.string "employee_name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "day_off"
    t.string "work_content"
    t.string "work_content_other"
    t.string "vehicle_model"
    t.string "chassis_number"
    t.string "pickup_location"
    t.string "delivery_location"
    t.integer "travel_distance"
    t.integer "fuel_fee"
    t.integer "toll_fee"
    t.integer "transportation_fee"
    t.integer "lodging_fee"
    t.string "fuel_fee_type"
    t.string "toll_fee_type"
    t.string "transportation_fee_type"
    t.string "lodging_fee_type"
    t.integer "fuel_amount"
    t.boolean "has_abnormality"
    t.text "remarks"
    t.boolean "status"
    t.boolean "status_1"
    t.boolean "status_2"
    t.text "fuel_fee_detail"
    t.text "toll_fee_detail"
    t.text "transportation_fee_detail"
    t.text "lodging_fee_detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "responsible_person"
  end

  create_table "in_entries", force: :cascade do |t|
    t.string "company_name"
    t.string "driver_name"
    t.string "model"
    t.string "chassis_number"
    t.string "pickup_location"
    t.boolean "has_abnormality"
    t.text "message"
    t.date "entry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "radio_company_name"
    t.string "radio_model"
    t.string "radio_pickup_location"
    t.integer "movement_record_id"
    t.index ["movement_record_id", "chassis_number"], name: "index_in_entries_on_movement_record_id_and_chassis_number", unique: true
    t.index ["movement_record_id"], name: "index_in_entries_on_movement_record_id"
  end

  create_table "movement_records", force: :cascade do |t|
    t.bigint "schedule_id"
    t.string "responsible_person"
    t.string "model"
    t.string "chassis_number"
    t.string "pickup_location"
    t.string "waypoint"
    t.string "delivery_location"
    t.datetime "departure_time"
    t.datetime "arrival_time"
    t.integer "departure_distance"
    t.integer "arrival_distance"
    t.string "toll_fee_type"
    t.integer "toll_fee"
    t.string "fuel_fee_type"
    t.integer "fuel_fee"
    t.boolean "has_abnormality"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "move_date"
    t.integer "departure_hour"
    t.integer "departure_minute"
    t.integer "arrival_hour"
    t.integer "arrival_minute"
    t.string "request_type"
    t.string "vehicle_condition"
    t.integer "lodging_fee"
    t.integer "transportation_fee"
    t.integer "fuel_amount"
    t.string "lodging_fee_type"
    t.string "transportation_fee_type"
    t.boolean "status", default: false
    t.boolean "status_1", default: false
    t.boolean "status_2", default: false
    t.text "fuel_fee_detail"
    t.text "toll_fee_detail"
    t.text "transportation_fee_detail"
    t.text "lodging_fee_detail"
    t.index ["schedule_id"], name: "index_movement_records_on_schedule_id"
  end

  create_table "out_entries", force: :cascade do |t|
    t.string "company_name"
    t.string "driver_name"
    t.string "model"
    t.string "chassis_number"
    t.string "delivery_location"
    t.boolean "has_abnormality"
    t.text "message"
    t.date "entry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "radio_company_name"
    t.string "radio_model"
    t.string "radio_pickup_location"
    t.string "radio_delivery_location"
    t.integer "movement_record_id"
    t.string "pickup_location"
    t.integer "entry_hour"
    t.integer "entry_minute"
    t.index ["movement_record_id"], name: "index_out_entries_on_movement_record_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "model"
    t.string "chassis_number"
    t.string "pickup_location"
    t.string "delivery_location"
    t.datetime "move_date", precision: nil
    t.text "comment"
    t.text "issue_detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_scheduled", default: false, null: false
    t.boolean "scheduled"
    t.string "model_other"
    t.string "pickup_other"
    t.string "delivery_other"
    t.index ["chassis_number"], name: "index_plans_on_chassis_number"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "model"
    t.string "chassis_number"
    t.string "pickup_location"
    t.string "delivery_location"
    t.datetime "schedule_date"
    t.string "responsible_person"
    t.text "note"
    t.integer "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment"
    t.boolean "is_completed"
    t.index ["plan_id"], name: "index_schedules_on_plan_id"
  end

  add_foreign_key "movement_records", "schedules"
  add_foreign_key "schedules", "plans"
end
