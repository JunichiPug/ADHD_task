class MemosController < ApplicationController
  # 🔐 ログイン必須
  before_action :authenticate_user!

  # 🔎 対象レコード取得（必要なアクションのみ）
  before_action :set_memo, only: %i[update destroy]

  # メモ一覧
  def index
    @memos = current_user.memos.order(created_at: :asc)
  end

  # 追加処理
  def create
    @memo = current_user.memos.build(memo_params)
    @memo.save
    redirect_to memos_path
  end

  # 更新処理（チェックの切り替え・内容編集）
  def update
    @memo.update(memo_params)
    redirect_to memos_path
  end

  # 削除処理
  def destroy
    @memo.destroy
    redirect_to memos_path
  end

  # 完了済みをまとめて削除
  def destroy_completed
    current_user.memos.where(done: true).destroy_all
    redirect_to memos_path
  end

  # すべて削除
  def destroy_all
    current_user.memos.destroy_all
    redirect_to memos_path
  end

  private

  # ログインユーザーのメモだけを取得（セキュリティ重要）
  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  # ストロングパラメータ
  def memo_params
    params.require(:memo).permit(:content, :done)
  end
end
