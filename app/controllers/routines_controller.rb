class RoutinesController < ApplicationController
  # 🔐 ログイン必須（全アクション保護）
  before_action :authenticate_user!

  # 🔎 対象レコード取得（必要なアクションのみ）
  before_action :set_routine, only: %i[show edit update destroy start]

  # ルーチン一覧
  def index
    @routines = current_user.routines
  end

  # ルーチン開始画面
  def start
    # このルーチンに紐づくタスク一覧
    @tasks = @routine.tasks
  end

  # 詳細画面
  def show
  end

  # 新規作成画面
  def new
    @routine = current_user.routines.build

    # 最初に空のタスクを1つ用意
    @routine.tasks.build
  end

  # 編集画面
  def edit
  end

  # 作成処理
  def create
    @routine = current_user.routines.build(routine_params)

    if @routine.save
      redirect_to routines_path, notice: "ルーチンを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 更新処理
  def update
    if @routine.update(routine_params)
      redirect_to routines_path, notice: "ルーチンを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  def destroy
    @routine.destroy
    redirect_to routines_path, notice: "ルーチンを削除しました。"
  end

  private

  # ログインユーザーのルーチンだけを取得（セキュリティ重要）
  def set_routine
    @routine = current_user.routines.find(params[:id])
  end

  # ストロングパラメータ
  def routine_params
    params.require(:routine).permit(
      :title,
      tasks_attributes: [:id, :title, :duration, :position, :_destroy]
    )
  end
end