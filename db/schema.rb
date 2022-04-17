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

ActiveRecord::Schema.define(version: 2022_04_17_064004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "action_mailbox_inbound_emails", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "telegram_id"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "booked_amounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "payment_system_id", null: false
    t.decimal "amount_cents", null: false
    t.string "amount_currency", null: false
    t.uuid "order_id", null: false
    t.datetime "created_at", null: false
    t.index ["order_id"], name: "index_booked_amounts_on_order_id"
    t.index ["payment_system_id"], name: "index_booked_amounts_on_payment_system_id"
  end

  create_table "cities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_cities_on_name", unique: true
  end

  create_table "credit_card_verifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id"
    t.uuid "user_id"
    t.string "session_id"
    t.string "number", null: false
    t.string "full_name", null: false
    t.string "state", null: false
    t.string "image", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reject_message"
    t.index ["order_id"], name: "index_credit_card_verifications_on_order_id"
    t.index ["user_id"], name: "index_credit_card_verifications_on_user_id"
  end

  create_table "credit_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "number", null: false
    t.uuid "verification_id", null: false
    t.string "full_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number"], name: "index_credit_cards_on_number", unique: true
    t.index ["verification_id"], name: "index_credit_cards_on_verification_id"
  end

  create_table "credit_cards_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "credit_card_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["credit_card_id", "user_id"], name: "index_credit_cards_users_on_credit_card_id_and_user_id", unique: true
    t.index ["credit_card_id"], name: "index_credit_cards_users_on_credit_card_id"
    t.index ["user_id"], name: "index_credit_cards_users_on_user_id"
  end

  create_table "currencies", id: :string, force: :cascade do |t|
    t.datetime "archived_at"
    t.datetime "updated_at"
    t.decimal "minimal_input_value_cents", null: false
    t.decimal "minimal_output_value_cents", null: false
    t.string "custom_bitfinex_ticker"
  end

  create_table "gera_cbr_external_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "date", null: false
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.float "rate", null: false
    t.float "original_rate", null: false
    t.integer "nominal", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cur_from", "cur_to", "date"], name: "index_cbr_external_rates_on_cur_from_and_cur_to_and_date", unique: true
  end

  create_table "gera_cross_rate_modes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "currency_rate_mode_id", null: false
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.uuid "rate_source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_rate_mode_id"], name: "index_cross_rate_modes_on_currency_rate_mode_id"
    t.index ["rate_source_id"], name: "index_cross_rate_modes_on_rate_source_id"
  end

  create_table "gera_currency_rate_history_intervals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "cur_from_iso_code", limit: 2, null: false
    t.integer "cur_to_iso_code", limit: 2, null: false
    t.float "min_rate", null: false
    t.float "avg_rate", null: false
    t.float "max_rate", null: false
    t.datetime "interval_from", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "interval_to", null: false
    t.index ["cur_from_iso_code", "cur_to_iso_code", "interval_from"], name: "crhi_unique_index", unique: true
    t.index ["interval_from"], name: "index_currency_rate_history_intervals_on_interval_from"
  end

  create_table "gera_currency_rate_mode_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.string "title"
    t.text "details"
    t.index ["status"], name: "index_currency_rate_mode_snapshots_on_status"
    t.index ["title"], name: "index_currency_rate_mode_snapshots_on_title", unique: true
  end

  create_table "gera_currency_rate_modes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.integer "mode", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "currency_rate_mode_snapshot_id", null: false
    t.string "cross_currency1"
    t.uuid "cross_rate_source1_id"
    t.string "cross_currency2"
    t.string "cross_currency3"
    t.uuid "cross_rate_source2_id"
    t.uuid "cross_rate_source3_id"
    t.index ["cross_rate_source1_id"], name: "index_currency_rate_modes_on_cross_rate_source1_id"
    t.index ["cross_rate_source2_id"], name: "index_currency_rate_modes_on_cross_rate_source2_id"
    t.index ["cross_rate_source3_id"], name: "index_currency_rate_modes_on_cross_rate_source3_id"
    t.index ["currency_rate_mode_snapshot_id", "cur_from", "cur_to"], name: "crm_id_pair", unique: true
  end

  create_table "gera_currency_rate_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "currency_rate_mode_snapshot_id", null: false
    t.index ["currency_rate_mode_snapshot_id"], name: "fk_rails_456167e2a9"
  end

  create_table "gera_currency_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.float "rate_value", null: false
    t.uuid "snapshot_id", null: false
    t.json "metadata", null: false
    t.datetime "created_at"
    t.uuid "external_rate_id"
    t.integer "mode", null: false
    t.uuid "rate_source_id"
    t.uuid "external_rate1_id"
    t.uuid "external_rate2_id"
    t.uuid "external_rate3_id"
    t.index ["created_at", "cur_from", "cur_to"], name: "currency_rates_created_at"
    t.index ["external_rate1_id"], name: "index_currency_rates_on_external_rate1_id"
    t.index ["external_rate2_id"], name: "index_currency_rates_on_external_rate2_id"
    t.index ["external_rate3_id"], name: "index_currency_rates_on_external_rate3_id"
    t.index ["external_rate_id"], name: "fk_rails_905ddd038e"
    t.index ["rate_source_id"], name: "fk_rails_2397c780d5"
    t.index ["snapshot_id", "cur_from", "cur_to"], name: "index_current_exchange_rates_uniq", unique: true
  end

  create_table "gera_direction_rate_history_intervals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "min_rate", null: false
    t.float "max_rate", null: false
    t.float "min_comission", null: false
    t.float "max_comission", null: false
    t.datetime "interval_from", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "interval_to", null: false
    t.uuid "payment_system_to_id", null: false
    t.uuid "payment_system_from_id", null: false
    t.float "avg_rate", null: false
    t.index ["interval_from", "payment_system_from_id", "payment_system_to_id"], name: "drhi_uniq", unique: true
    t.index ["payment_system_from_id"], name: "fk_rails_70f35124fc"
    t.index ["payment_system_to_id"], name: "fk_rails_5c92dd1b7f"
  end

  create_table "gera_direction_rate_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "gera_direction_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ps_from_id", null: false
    t.uuid "ps_to_id", null: false
    t.uuid "currency_rate_id", null: false
    t.float "rate_value", null: false
    t.float "base_rate_value", null: false
    t.float "rate_percent", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "exchange_rate_id", null: false
    t.boolean "is_used", default: false, null: false
    t.uuid "snapshot_id"
    t.index ["created_at", "ps_from_id", "ps_to_id"], name: "direction_rates_created_at"
    t.index ["currency_rate_id"], name: "fk_rails_d6f1847478"
    t.index ["exchange_rate_id", "id"], name: "index_direction_rates_on_exchange_rate_id_and_id"
    t.index ["ps_from_id", "ps_to_id", "id"], name: "index_direction_rates_on_ps_from_id_and_ps_to_id_and_id"
    t.index ["ps_to_id"], name: "fk_rails_fbaf7f33e1"
    t.index ["snapshot_id"], name: "fk_rails_392aafe0ef"
  end

  create_table "gera_exchange_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "income_payment_system_id", null: false
    t.string "in_cur", limit: 6, null: false
    t.string "out_cur", limit: 6, null: false
    t.uuid "outcome_payment_system_id", null: false
    t.float "value", null: false
    t.boolean "is_enabled", default: false, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["income_payment_system_id", "outcome_payment_system_id"], name: "exchange_rate_unique_index", unique: true
    t.index ["is_enabled"], name: "index_exchange_rates_on_is_enabled"
    t.index ["outcome_payment_system_id"], name: "fk_rails_ef77ea3609"
  end

  create_table "gera_external_rate_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "rate_source_id", null: false
    t.datetime "actual_for", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.index ["rate_source_id", "actual_for"], name: "index_external_rate_snapshots_on_rate_source_id_and_actual_for", unique: true
    t.index ["rate_source_id"], name: "index_external_rate_snapshots_on_rate_source_id"
  end

  create_table "gera_external_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "source_id", null: false
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.float "rate_value"
    t.uuid "snapshot_id", null: false
    t.datetime "created_at"
    t.index ["snapshot_id", "cur_from", "cur_to"], name: "index_external_rates_on_snapshot_id_and_cur_from_and_cur_to", unique: true
    t.index ["source_id"], name: "index_external_rates_on_source_id"
  end

  create_table "gera_payment_systems", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 60
    t.integer "priority", limit: 2
    t.string "currency_iso_code", null: false
    t.boolean "income_enabled", default: false, null: false
    t.boolean "outcome_enabled", default: false, null: false
    t.datetime "archived_at"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "is_available", default: true, null: false
    t.string "icon"
    t.float "commission", default: 0.0, null: false
    t.decimal "minimal_income_amount_cents", default: "0.0", null: false
    t.decimal "maximal_income_amount_cents", default: "1000.0", null: false
    t.decimal "minimal_outcome_amount_cents", default: "1.0", null: false
    t.decimal "maximal_outcome_amount_cents", default: "1000.0", null: false
    t.string "bestchange_key", null: false
    t.decimal "reserves_delta_cents", default: "0.0", null: false
    t.uuid "reserves_aggregator_id"
    t.string "system_type"
    t.string "wallet_name", default: "Wallet", null: false
    t.string "address_format"
    t.string "wrong_address_format_message", default: "Неверный формат", null: false
    t.string "available_outcome_card_brands", default: "", null: false
    t.boolean "require_full_name_on_income", default: false, null: false
    t.boolean "require_full_name_on_outcome", default: false, null: false
    t.boolean "require_email_on_income", default: false, null: false
    t.boolean "require_email_on_outcome", default: false, null: false
    t.boolean "require_verify", default: false, null: false
    t.boolean "require_verify_income_card", default: false, null: false
    t.boolean "require_phone_on_income", default: false, null: false
    t.boolean "require_phone_on_outcome", default: false, null: false
    t.boolean "require_telegram_on_income", default: false, null: false
    t.boolean "require_telegram_on_outcome", default: false, null: false
    t.boolean "require_city_on_income", default: false, null: false
    t.boolean "require_city_on_outcome", default: false, null: false
    t.text "order_comment"
    t.index ["bestchange_key"], name: "index_gera_payment_systems_on_bestchange_key", unique: true
    t.index ["income_enabled"], name: "index_payment_systems_on_income_enabled"
    t.index ["outcome_enabled"], name: "index_payment_systems_on_outcome_enabled"
    t.index ["reserves_aggregator_id"], name: "index_gera_payment_systems_on_reserves_aggregator_id"
  end

  create_table "gera_rate_sources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key", null: false
    t.uuid "actual_snapshot_id"
    t.integer "priority", default: 0, null: false
    t.boolean "is_enabled", default: true, null: false
    t.jsonb "supported_tickers", default: [], null: false
    t.datetime "supported_tickers_updated_at"
    t.index ["actual_snapshot_id"], name: "fk_rails_0b6cf3ddaa"
    t.index ["key"], name: "index_rate_sources_on_key", unique: true
    t.index ["title"], name: "index_rate_sources_on_title", unique: true
  end

  create_table "openbill_accounts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "owner_id"
    t.uuid "category_id", null: false
    t.string "key", limit: 256
    t.decimal "amount_cents", default: "0.0", null: false
    t.string "amount_currency", limit: 8, default: "USD", null: false
    t.text "details"
    t.integer "transactions_count", default: 0, null: false
    t.hstore "meta", default: {}, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }
    t.string "reference_type"
    t.uuid "reference_id"
    t.index ["created_at"], name: "index_accounts_on_created_at"
    t.index ["id"], name: "index_accounts_on_id", unique: true
    t.index ["key"], name: "index_accounts_on_key", unique: true, where: "(key IS NOT NULL)"
    t.index ["meta"], name: "index_accounts_on_meta", using: :gin
    t.index ["reference_type", "reference_id"], name: "index_openbill_accounts_on_reference"
  end

  create_table "openbill_categories", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", limit: 256, null: false
    t.uuid "parent_id"
    t.index ["parent_id", "name"], name: "index_openbill_categories_name", unique: true
  end

  create_table "openbill_invoices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "date", default: -> { "CURRENT_DATE" }, null: false
    t.string "number", limit: 256, null: false
    t.string "title", limit: 256, null: false
    t.uuid "destination_account_id", null: false
    t.decimal "amount_cents", default: "0.0", null: false
    t.string "amount_currency", limit: 3, default: "USD", null: false
    t.decimal "paid_cents", default: "0.0", null: false
    t.datetime "created_at", default: -> { "now()" }
    t.datetime "updated_at", default: -> { "now()" }
    t.jsonb "meta", default: {}
    t.text "details"
    t.index ["id"], name: "index_invoices_on_id", unique: true
    t.index ["number"], name: "index_invoices_on_number", unique: true
  end

  create_table "openbill_policies", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", limit: 256, null: false
    t.uuid "from_category_id"
    t.uuid "to_category_id"
    t.uuid "from_account_id"
    t.uuid "to_account_id"
    t.boolean "allow_reverse", default: true, null: false
    t.index ["name"], name: "index_openbill_policies_name", unique: true
  end

  create_table "openbill_transactions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "owner_id"
    t.string "username", limit: 255, null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.uuid "from_account_id", null: false
    t.uuid "to_account_id", null: false
    t.decimal "amount_cents", null: false
    t.string "amount_currency", limit: 8, null: false
    t.string "key", limit: 256, null: false
    t.text "details", null: false
    t.hstore "meta", default: {}, null: false
    t.uuid "reverse_transaction_id"
    t.uuid "invoice_id"
    t.index ["created_at"], name: "index_transactions_on_created_at"
    t.index ["key"], name: "index_transactions_on_key", unique: true
    t.index ["meta"], name: "index_transactions_on_meta", using: :gin
    t.check_constraint "amount_cents > (0)::numeric", name: "positive"
    t.check_constraint "to_account_id <> from_account_id", name: "different_accounts"
  end

  create_table "order_actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.string "custom_message"
    t.uuid "operator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "key", null: false
    t.index ["operator_id"], name: "index_order_actions_on_operator_id"
    t.index ["order_id"], name: "index_order_actions_on_order_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "income_amount_cents", null: false
    t.string "income_amount_currency", null: false
    t.decimal "outcome_amount_cents", null: false
    t.string "outcome_amount_currency", null: false
    t.uuid "income_payment_system_id", null: false
    t.uuid "outcome_payment_system_id", null: false
    t.uuid "direction_rate_id"
    t.json "direction_rate_dump", null: false
    t.decimal "rate_value", null: false
    t.decimal "base_rate_value", null: false
    t.decimal "rate_percent", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "rate_calculation_dump", null: false
    t.string "ref_token"
    t.uuid "referrer_id"
    t.uuid "user_id"
    t.uuid "operator_id"
    t.integer "request_direction", default: 0, null: false
    t.string "uid", null: false
    t.uuid "income_wallet_id", null: false
    t.uuid "outcome_wallet_id", null: false
    t.string "income_address", null: false
    t.datetime "user_confirmed_at"
    t.string "cancel_reason"
    t.string "user_remote_ip"
    t.string "user_agent"
    t.string "state", default: "draft", null: false
    t.decimal "referrer_accrual_method"
    t.decimal "referrer_profit_percentage"
    t.decimal "referrer_income_percentage"
    t.decimal "referrer_reward_cents"
    t.string "referrer_reward_currency"
    t.decimal "based_income_amount_cents", null: false
    t.string "based_income_amount_currency", null: false
    t.string "user_income_address"
    t.string "full_name"
    t.string "user_full_name"
    t.string "user_email"
    t.string "user_phone"
    t.string "user_telegram"
    t.uuid "city_id"
    t.uuid "gera_direction_rates_id"
    t.index ["city_id"], name: "index_orders_on_city_id"
    t.index ["direction_rate_id"], name: "index_orders_on_direction_rate_id"
    t.index ["gera_direction_rates_id"], name: "index_orders_on_gera_direction_rates_id"
    t.index ["income_payment_system_id"], name: "index_orders_on_income_payment_system_id"
    t.index ["income_wallet_id"], name: "index_orders_on_income_wallet_id"
    t.index ["operator_id"], name: "index_orders_on_operator_id"
    t.index ["outcome_payment_system_id"], name: "index_orders_on_outcome_payment_system_id"
    t.index ["outcome_wallet_id"], name: "index_orders_on_outcome_wallet_id"
    t.index ["referrer_id"], name: "index_orders_on_referrer_id"
    t.index ["state"], name: "index_orders_on_state"
    t.index ["uid"], name: "index_orders_on_uid", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "path", null: false
    t.string "menu_title", null: false
    t.string "html_title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["path"], name: "index_pages_on_path", unique: true
  end

  create_table "partners", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "ref_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "accrual_method", default: 0, null: false
    t.decimal "profit_percentage", default: "10.0", null: false
    t.decimal "income_percentage", default: "0.1", null: false
    t.index ["ref_token"], name: "index_partners_on_ref_token", unique: true
    t.index ["user_id"], name: "index_partners_on_user_id", unique: true
  end

  create_table "site_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_site_settings_on_key", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallet_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "wallet_id", null: false
    t.decimal "amount_cents", null: false
    t.uuid "opposit_account_id", null: false
    t.text "details", null: false
    t.uuid "admin_user_id", null: false
    t.integer "activity_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "amount_currency", null: false
    t.index ["admin_user_id"], name: "index_wallet_activities_on_admin_user_id"
    t.index ["opposit_account_id"], name: "index_wallet_activities_on_opposit_account_id"
    t.index ["wallet_id"], name: "index_wallet_activities_on_wallet_id"
  end

  create_table "wallets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "payment_system_id", null: false
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "account_id", null: false
    t.datetime "archived_at"
    t.string "address", null: false
    t.boolean "income_enabled", default: true, null: false
    t.boolean "outcome_enabled", default: true, null: false
    t.datetime "last_used_as_income_at"
    t.datetime "last_used_as_outcome_at"
    t.index ["account_id"], name: "index_wallets_on_account_id"
    t.index ["address"], name: "index_wallets_on_address", unique: true
    t.index ["payment_system_id"], name: "index_wallets_on_payment_system_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "booked_amounts", "gera_payment_systems", column: "payment_system_id"
  add_foreign_key "booked_amounts", "orders"
  add_foreign_key "credit_card_verifications", "orders"
  add_foreign_key "credit_card_verifications", "users"
  add_foreign_key "credit_cards", "credit_card_verifications", column: "verification_id"
  add_foreign_key "credit_cards_users", "credit_cards"
  add_foreign_key "credit_cards_users", "users"
  add_foreign_key "gera_cross_rate_modes", "gera_currency_rate_modes", column: "currency_rate_mode_id", on_delete: :cascade
  add_foreign_key "gera_cross_rate_modes", "gera_rate_sources", column: "rate_source_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_modes", "gera_currency_rate_mode_snapshots", column: "currency_rate_mode_snapshot_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_modes", "gera_rate_sources", column: "cross_rate_source1_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_modes", "gera_rate_sources", column: "cross_rate_source2_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_modes", "gera_rate_sources", column: "cross_rate_source3_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_snapshots", "gera_currency_rate_mode_snapshots", column: "currency_rate_mode_snapshot_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_currency_rate_snapshots", column: "snapshot_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_external_rates", column: "external_rate1_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_external_rates", column: "external_rate2_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_external_rates", column: "external_rate3_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_external_rates", column: "external_rate_id", on_delete: :nullify
  add_foreign_key "gera_currency_rates", "gera_rate_sources", column: "rate_source_id", on_delete: :cascade
  add_foreign_key "gera_direction_rate_history_intervals", "gera_payment_systems", column: "payment_system_from_id", on_delete: :cascade
  add_foreign_key "gera_direction_rate_history_intervals", "gera_payment_systems", column: "payment_system_to_id", on_delete: :cascade
  add_foreign_key "gera_direction_rates", "gera_currency_rates", column: "currency_rate_id", on_delete: :cascade
  add_foreign_key "gera_direction_rates", "gera_exchange_rates", column: "exchange_rate_id", on_delete: :cascade
  add_foreign_key "gera_direction_rates", "gera_payment_systems", column: "ps_from_id", on_delete: :cascade
  add_foreign_key "gera_direction_rates", "gera_payment_systems", column: "ps_to_id", on_delete: :cascade
  add_foreign_key "gera_exchange_rates", "gera_payment_systems", column: "income_payment_system_id", on_delete: :cascade
  add_foreign_key "gera_exchange_rates", "gera_payment_systems", column: "outcome_payment_system_id", on_delete: :cascade
  add_foreign_key "gera_external_rates", "gera_external_rate_snapshots", column: "snapshot_id", on_delete: :cascade
  add_foreign_key "gera_external_rates", "gera_rate_sources", column: "source_id", on_delete: :cascade
  add_foreign_key "gera_payment_systems", "gera_payment_systems", column: "reserves_aggregator_id"
  add_foreign_key "openbill_accounts", "openbill_categories", column: "category_id", name: "openbill_accounts_category_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_categories", "openbill_categories", column: "parent_id", name: "openbill_categories_parent_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_invoices", "openbill_accounts", column: "destination_account_id", name: "openbill_invoices_destination_account_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_policies", "openbill_accounts", column: "from_account_id", name: "openbill_policies_from_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_accounts", column: "to_account_id", name: "openbill_policies_to_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "from_category_id", name: "openbill_policies_from_category_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "to_category_id", name: "openbill_policies_to_category_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "from_account_id", name: "openbill_transactions_from_account_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "to_account_id", name: "openbill_transactions_to_account_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_invoices", column: "invoice_id", name: "openbill_transactions_invoice_id_fk", on_delete: :restrict
  add_foreign_key "openbill_transactions", "openbill_transactions", column: "reverse_transaction_id", name: "reverse_transaction_foreign_key"
  add_foreign_key "order_actions", "admin_users", column: "operator_id"
  add_foreign_key "order_actions", "orders"
  add_foreign_key "orders", "admin_users", column: "operator_id"
  add_foreign_key "orders", "cities"
  add_foreign_key "orders", "gera_payment_systems", column: "income_payment_system_id"
  add_foreign_key "orders", "gera_payment_systems", column: "outcome_payment_system_id"
  add_foreign_key "orders", "partners", column: "referrer_id"
  add_foreign_key "orders", "users"
  add_foreign_key "orders", "wallets", column: "income_wallet_id"
  add_foreign_key "orders", "wallets", column: "outcome_wallet_id"
  add_foreign_key "partners", "users"
  add_foreign_key "wallet_activities", "openbill_accounts", column: "opposit_account_id"
  add_foreign_key "wallet_activities", "wallets"
  add_foreign_key "wallets", "gera_payment_systems", column: "payment_system_id"
  add_foreign_key "wallets", "openbill_accounts", column: "account_id"
  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.add_current_user_to_transaction()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.username := current_user;
  RETURN NEW;
END
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER add_current_user_to_transaction BEFORE INSERT OR UPDATE ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION add_current_user_to_transaction()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.constraint_accounts_currency_in_transactions()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM * FROM OPENBILL_ACCOUNTS where id = NEW.from_account_id and amount_currency = NEW.amount_currency;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (from #%) has wrong currency', NEW.from_account_id;
  END IF;

  PERFORM * FROM OPENBILL_ACCOUNTS where id = NEW.to_account_id and amount_currency = NEW.amount_currency;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (to #%) has wrong currency', NEW.to_account_id;
  END IF;

  IF NEW.invoice_id IS NOT NULL THEN
    PERFORM * FROM OPENBILL_INVOICES where id = NEW.invoice_id and amount_currency = NEW.amount_currency;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Invoice (to #%) has wrong currency', NEW.invoice_id;
    END IF;

    PERFORM * FROM OPENBILL_INVOICES where id = NEW.invoice_id and destination_account_id = NEW.to_account_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Invoice destination account (to #%) is wrong', NEW.invoice_id;
    END IF;
  END IF;

  return NEW;
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER constraint_accounts_currency_in_transactions BEFORE INSERT OR UPDATE ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION constraint_accounts_currency_in_transactions()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.constraint_transaction_ownership()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM id FROM OPENBILL_ACCOUNTS WHERE id = NEW.from_account_id and (owner_id = NEW.owner_id OR (owner_id is NULL and NEW.owner_id is NULL) );
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No such source account in this owner (to #%)', NEW.owner_id;
  END IF;

  PERFORM id FROM OPENBILL_ACCOUNTS WHERE id = NEW.to_account_id and (owner_id = NEW.owner_id OR (owner_id is NULL and NEW.owner_id is NULL) );
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No such destination account in this owner (to #%)', NEW.owner_id;
  END IF;


  return NEW;
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER constraint_transaction_ownership AFTER INSERT ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION constraint_transaction_ownership()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.disable_delete_account()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  RAISE EXCEPTION 'Cannot delete account';
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER disable_delete_account BEFORE DELETE ON \"openbill_accounts\" FOR EACH ROW EXECUTE FUNCTION disable_delete_account()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.notify_transaction()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM pg_notify('openbill_transactions', CAST(NEW.id AS text));

  return NEW;
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER notify_transaction AFTER INSERT ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION notify_transaction()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.openbill_transaction_delete()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  -- установить last_transaction_id, counts и _at
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents - OLD.amount_cents, transactions_count = transactions_count - 1 WHERE id = OLD.to_account_id;
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents + OLD.amount_cents, transactions_count = transactions_count - 1 WHERE id = OLD.from_account_id;

  UPDATE OPENBILL_INVOICES SET paid_cents = -OLD.amount_cents WHERE id = OLD.invoice_id;

  return OLD;
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER openbill_transaction_delete BEFORE DELETE ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION openbill_transaction_delete()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.openbill_transaction_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN

  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents - OLD.amount_cents, transactions_count = transactions_count - 1 WHERE id = OLD.to_account_id;
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents + NEW.amount_cents, transactions_count = transactions_count + 1 WHERE id = NEW.to_account_id;

  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents + OLD.amount_cents, transactions_count = transactions_count - 1 WHERE id = OLD.from_account_id;
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents - NEW.amount_cents, transactions_count = transactions_count + 1 WHERE id = NEW.from_account_id;

  UPDATE OPENBILL_INVOICES SET paid_cents = paid_cents - OLD.amount_cents + NEW.amount_cents WHERE id = NEW.invoice_id;

  return NEW;
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER openbill_transaction_update AFTER UPDATE ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION openbill_transaction_update()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.process_account_transaction()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- У всех счетов и транзакции должна быть одинаковая валюта

  PERFORM * FROM OPENBILL_ACCOUNTS where id = NEW.from_account_id and amount_currency = NEW.amount_currency;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (from #%) has wrong currency', NEW.from_account_id;
  END IF;

  PERFORM * FROM OPENBILL_ACCOUNTS where id = NEW.to_account_id and amount_currency = NEW.amount_currency;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (to #%) has wrong currency', NEW.to_account_id;
  END IF;

  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents - NEW.amount_cents, transactions_count = transactions_count + 1 WHERE id = NEW.from_account_id;
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents + NEW.amount_cents, transactions_count = transactions_count + 1 WHERE id = NEW.to_account_id;

  UPDATE OPENBILL_INVOICES SET paid_cents = paid_cents + NEW.amount_cents WHERE id = NEW.invoice_id;

  return NEW;
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER process_account_transaction AFTER INSERT ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION process_account_transaction()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.process_reverse_transaction()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.reverse_transaction_id IS NOT NULL THEN
    PERFORM * FROM openbill_transactions
      WHERE amount_cents = NEW.amount_cents 
        AND amount_currency = NEW.amount_currency 
        AND from_account_id = NEW.to_account_id
        AND to_account_id = NEW.from_account_id
        AND id = NEW.reverse_transaction_id;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Not found reverse transaction with same accounts and amount (#%)', NEW.reverse_transaction_id;
    END IF;

  END IF;

  return NEW;
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER process_reverse_transaction AFTER INSERT ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION process_reverse_transaction()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.restrict_transaction()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  _from_category_id uuid;
  _to_category_id uuid;
BEGIN
  SELECT category_id FROM OPENBILL_ACCOUNTS where id = NEW.from_account_id INTO _from_category_id;
  SELECT category_id FROM OPENBILL_ACCOUNTS where id = NEW.to_account_id INTO _to_category_id;
  PERFORM * FROM OPENBILL_POLICIES WHERE 
    (
      NEW.reverse_transaction_id is null AND
      (from_category_id is null OR from_category_id = _from_category_id) AND
      (to_category_id is null OR to_category_id = _to_category_id) AND
      (from_account_id is null OR from_account_id = NEW.from_account_id) AND
      (to_account_id is null OR to_account_id = NEW.to_account_id)
    ) OR
    (
      NEW.reverse_transaction_id is not null AND
      (to_category_id is null OR to_category_id = _from_category_id) AND
      (from_category_id is null OR from_category_id = _to_category_id) AND
      (to_account_id is null OR to_account_id = NEW.from_account_id) AND
      (from_account_id is null OR from_account_id = NEW.to_account_id) AND
      allow_reverse
    );

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No policy for this transaction';
  END IF;

  RETURN NEW;
END

$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER restrict_transaction AFTER INSERT ON \"openbill_transactions\" FOR EACH ROW EXECUTE FUNCTION restrict_transaction()")

end
