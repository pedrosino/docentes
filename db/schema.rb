# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160622123000) do

  create_table "areas", force: :cascade do |t|
    t.integer  "unidade_id",               limit: 4
    t.string   "campus",                   limit: 255
    t.string   "nome",                     limit: 255
    t.string   "subarea",                  limit: 255
    t.string   "regime",                   limit: 255
    t.integer  "vagas",                    limit: 4
    t.boolean  "prorrogar"
    t.text     "qualif_prorrogar",         limit: 65535
    t.datetime "data_prova"
    t.string   "tipo",                     limit: 255
    t.string   "edital_id",                limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "responsavel",              limit: 255
    t.string   "situacao",                 limit: 255
    t.text     "disciplinas",              limit: 65535
    t.boolean  "prova_didatica"
    t.boolean  "prova_procedimental"
    t.string   "min_procedimental",        limit: 255
    t.string   "max_procedimental",        limit: 255
    t.string   "curso",                    limit: 255
    t.integer  "vagas_negros",             limit: 4
    t.integer  "vagas_pcd",                limit: 4
    t.integer  "coautoria",                limit: 4
    t.boolean  "confirmada"
    t.integer  "vaga_id",                  limit: 4
    t.string   "tipo_vaga",                limit: 255
    t.string   "nome_vaga",                limit: 255
    t.boolean  "graduacao"
    t.text     "descricao_graduacao",      limit: 65535
    t.boolean  "especializacao"
    t.text     "descricao_especializacao", limit: 65535
    t.boolean  "mestrado"
    t.text     "descricao_mestrado",       limit: 65535
    t.boolean  "doutorado"
    t.text     "descricao_doutorado",      limit: 65535
    t.text     "observacao",               limit: 65535
    t.boolean  "mantem_qualificacao"
  end

  add_index "areas", ["unidade_id"], name: "fk_rails_7e4c0346f5", using: :btree

  create_table "criterios", force: :cascade do |t|
    t.string   "nome",       limit: 255
    t.text     "descricao",  limit: 65535
    t.string   "tipo_prova", limit: 255
    t.decimal  "valor",                    precision: 6, scale: 3
    t.integer  "area_id",    limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "editais", force: :cascade do |t|
    t.string   "numero",            limit: 255
    t.string   "data",              limit: 255
    t.date     "comeca_inscricao"
    t.date     "termina_inscricao"
    t.string   "tipo",              limit: 255
    t.date     "publicacao"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "situacao",          limit: 255
    t.string   "num_processo",      limit: 255
  end

  create_table "posts", force: :cascade do |t|
    t.string   "titulo",     limit: 255
    t.text     "corpo",      limit: 65535
    t.datetime "data"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "titulos", force: :cascade do |t|
    t.text     "descricao",      limit: 65535
    t.decimal  "valor",                        precision: 6, scale: 3
    t.decimal  "maximo",                       precision: 6, scale: 3
    t.string   "tipo",           limit: 255
    t.string   "unidade_medida", limit: 255
    t.integer  "area_id",        limit: 4
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.boolean  "prorrogacao",                                          default: false
  end

  create_table "unidades", force: :cascade do |t|
    t.string   "sigla",      limit: 5
    t.string   "nome",       limit: 255
    t.string   "email",      limit: 255
    t.string   "diretor",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "telefone",   limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "nome",                   limit: 255,              null: false
    t.string   "tipo",                   limit: 255
    t.integer  "unidade_id",             limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unidade_id"], name: "fk_rails_94265554cc", using: :btree

  create_table "vagas", force: :cascade do |t|
    t.integer  "codigo",      limit: 4
    t.string   "tipo",        limit: 255
    t.string   "nome",        limit: 255
    t.integer  "unidade_id",  limit: 4
    t.string   "situacao",    limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.date     "data_inicio"
    t.date     "data_fim"
    t.string   "regime",      limit: 255
    t.string   "campus",      limit: 255
    t.text     "observacao",  limit: 65535
  end

  add_foreign_key "areas", "unidades"
  add_foreign_key "users", "unidades"
end
