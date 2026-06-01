class RoutinesController < ApplicationController
  # 指定されたアクションが動く前に、対象のルーチンをデータベースから特定する
  before_action :set_routine, only: %i[ show edit update destroy ]

  # GET /routines
  # ルーチン一覧画面を表示する
  def index
    @routines = current_user.routines.all
  end

  # GET /routines/1
  # ルーチンの詳細画面を表示する（必要に応じて使用）
  def show
  end

  # GET /routines/new
  # ルーチンの新規作成画面を表示する
  def new
    @routine = current_user.routines.build
    # 新規作成時、最初から空のタスク入力欄を1つ用意しておく場合
    @routine.tasks.build
  end

  # GET /routines/1/edit
  # ルーチンの編集画面を表示する
  def edit
    # 💡 ログより：@routine.tasks はビュー側で自動ロードされるためここでは明示しなくてOKです
  end

  # POST /routines
  # 新しいルーチンをデータベースに保存する
  def create
    @routine = current_user.routines.build(routine_params)

    if @routine.save
      # 💡 保存に成功したら、ルーチン一覧画面（/routines）に遷移する
      redirect_to routines_path, notice: "ルーチンを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /routines/1
  # 既存のルーチン（と紐づくタスク）を更新する
  def update
    if @routine.update(routine_params)
      # 💡 【今回の肝】更新に成功したら、編集画面ではなくルーチン一覧画面（/routines）に遷移する
      redirect_to routines_path, notice: "ルーチンを更新しました。"
    else
      # バリデーションエラーなどがあれば編集画面を再描画する
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /routines/1
  # ルーチンを削除する
  def destroy
    @routine.destroy
    redirect_to routines_path, notice: "ルーチンを削除しました。"
  end

  private

  # ログに登場した「SELECT "routines".* FROM "routines" WHERE "routines"."user_id" = $1 AND "routines"."id" = $2」を再現
  def set_routine
    @routine = current_user.routines.find(params[:id])
  end

  # ストロングパラメータ
  # 安全にデータを保存するために、許可する項目を定義します
  def routine_params
    # 💡 ルーチンのタイトルだけでなく、紐づくタスク（id, タイトル, 所要時間, 削除フラグ）の保存・編集もまとめて許可します
    params.require(:routine).permit(
      :title, 
      tasks_attributes: [:id, :title, :duration, :_destroy]
    )
  end
end