require 'rails_helper'
require "cancan/matchers"

Rails.describe Ability, type: :model do
  describe 'abilities' do
    describe 'when is evo_super' do
      before(:each) do
        @evo_super_user = create(:user, :evo_super)
        @other_evo_user = create(:user, :evo)
        @brand_user = create(:user, :brand)
        @evo_super_user.confirm
        @ability = Ability.new(@evo_super_user)
      end
      context 'Startup abilities' do
        it { expect(@ability).to be_able_to(:create, Startup) }
        it { expect(@ability).to be_able_to(:index, Startup) }
        it { expect(@ability).to be_able_to(:profile, Startup) }
        it { expect(@ability).to be_able_to(:questions, Startup) }
        it { expect(@ability).to be_able_to(:profile_activity, Startup) }
        it { expect(@ability).to be_able_to(:notes, Startup) }
        it { expect(@ability).to be_able_to(:watchlist, Startup) }
        it { expect(@ability).to be_able_to(:new_push_to_brand, Startup) }
        it { expect(@ability).to be_able_to(:push_to_brand, Startup) }
        it { expect(@ability).to be_able_to(:new_add_to_list, Startup) }
        it { expect(@ability).to be_able_to(:add_to_list, Startup) }
        it { expect(@ability).not_to be_able_to(:requests, Startup) }
        it { expect(@ability).not_to be_able_to(:home, Startup) }
        it { expect(@ability).not_to be_able_to(:update, Startup) }
        it { expect(@ability).to be_able_to(:create, StartupProfileQuestion) }
        it { expect(@ability).to be_able_to(:index, StartupProfileQuestion) }
        #not being able to update question means that user cannot answer it
        it { expect(@ability).not_to be_able_to(:update, StartupProfileQuestion) }
      end
      context 'List abilities' do
        it { expect(@ability).to be_able_to(:create, List) }
        it { expect(@ability).to be_able_to(:add_to_favorites, List) }
        it { expect(@ability).to be_able_to(:destroy, List.new(author_id: @evo_super_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:destroy, List.new(author_id: @other_evo_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:destroy, List.new(author_id: @evo_super_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @other_evo_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @evo_super_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @evo_super_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:remove_from_favorites, List.new(author_id: @evo_super_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:remove_from_favorites, List.new(author_id: @other_evo_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:remove_from_favorites, List.new(author_id: @brand_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:update, List.new(author_id: @brand_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:read, List.new(author_id: @evo_super_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @brand_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @brand_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @other_evo_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:remove_from, List.new(author_id: @evo_super_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:remove_from, List.new(author_id: @other_evo_user.id, favorite: false)) }
      end
      context 'Tag abilities' do
        it { expect(@ability).to be_able_to(:create, Tag) }
        it { expect(@ability).to be_able_to(:read, Tag.new(team: 'evo')) }
        it { expect(@ability).to be_able_to(:destroy, Tag.new(team: 'evo')) }
      end
      context 'Note abilities' do
        it { expect(@ability).to be_able_to(:create, Note) }
        it { expect(@ability).to be_able_to(:read, Note) }
        it { expect(@ability).to be_able_to(:update, Note.new(author_id: @evo_super_user.id)) }
        it { expect(@ability).to be_able_to(:update, Note.new(assignee_id: @evo_super_user.id)) }
        it { expect(@ability).to be_able_to(:read, Note.new(assignee_id: @evo_super_user.id)) }
        it { expect(@ability).to be_able_to(:read, Note.new(author_id: @evo_super_user.id)) }
        it { expect(@ability).not_to be_able_to(:destroy, Note.new(author_id: @other_evo_user.id)) }
        it { expect(@ability).not_to be_able_to(:destroy, Note.new(assignee_id: @other_evo_user.id)) }
      end
    end
    describe 'when is evo' do
      before(:each) do
        @evo_user = create(:user, :evo)
        @other_evo_user = create(:user, :evo)
        @brand_user = create(:user, :brand)
        @evo_user.confirm
        @ability = Ability.new(@evo_user)
      end
      context 'Startup abilities' do
        it { expect(@ability).to be_able_to(:create, Startup) }
        it { expect(@ability).to be_able_to(:index, Startup) }
        it { expect(@ability).to be_able_to(:profile, Startup) }
        it { expect(@ability).to be_able_to(:questions, Startup) }
        it { expect(@ability).to be_able_to(:profile_activity, Startup) }
        it { expect(@ability).to be_able_to(:notes, Startup) }
        it { expect(@ability).to be_able_to(:watchlist, Startup) }
        it { expect(@ability).to be_able_to(:new_push_to_brand, Startup) }
        it { expect(@ability).to be_able_to(:push_to_brand, Startup) }
        it { expect(@ability).to be_able_to(:new_add_to_list, Startup) }
        it { expect(@ability).to be_able_to(:add_to_list, Startup) }
        it { expect(@ability).not_to be_able_to(:requests, Startup) }
        it { expect(@ability).not_to be_able_to(:home, Startup) }
        it { expect(@ability).not_to be_able_to(:update, Startup) }
        it { expect(@ability).to be_able_to(:create, StartupProfileQuestion) }
        it { expect(@ability).to be_able_to(:index, StartupProfileQuestion) }
        #not being able to update question means that user cannot answer it
        it { expect(@ability).not_to be_able_to(:update, StartupProfileQuestion) }
      end
      context 'List abilities' do
        it { expect(@ability).to be_able_to(:create, List) }
        it { expect(@ability).to be_able_to(:add_to_favorites, List) }
        it { expect(@ability).to be_able_to(:destroy, List.new(author_id: @evo_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:read, List.new(author_id: @evo_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:destroy, List.new(author_id: @other_evo_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:destroy, List.new(author_id: @evo_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @other_evo_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @evo_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @evo_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:remove_from_favorites, List.new(author_id: @evo_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:remove_from_favorites, List.new(author_id: @other_evo_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:remove_from_favorites, List.new(author_id: @brand_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:update, List.new(author_id: @brand_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @brand_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @brand_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @other_evo_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:remove_from, List.new(author_id: @evo_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:remove_from, List.new(author_id: @other_evo_user.id, favorite: false)) }
      end
      context 'Tag abilities' do
        it { expect(@ability).to be_able_to(:create, Tag) }
        it { expect(@ability).to be_able_to(:read, Tag.new(team: 'evo')) }
        it { expect(@ability).to be_able_to(:destroy, Tag.new(team: 'evo')) }
      end
      context 'Note abilities' do
        it { expect(@ability).to be_able_to(:create, Note) }
        it { expect(@ability).to be_able_to(:read, Note) }
        it { expect(@ability).to be_able_to(:update, Note.new(author_id: @evo_user.id)) }
        it { expect(@ability).to be_able_to(:update, Note.new(assignee_id: @evo_user.id)) }
        it { expect(@ability).to be_able_to(:read, Note.new(assignee_id: @evo_user.id)) }
        it { expect(@ability).to be_able_to(:read, Note.new(author_id: @evo_user.id)) }
        it { expect(@ability).not_to be_able_to(:destroy, Note.new(author_id: @other_evo_user.id)) }
        it { expect(@ability).not_to be_able_to(:destroy, Note.new(assignee_id: @other_evo_user.id)) }
      end
    end
    describe 'when is brand_super' do
      before(:each) do
        @brand_super_user = create(:user, :brand_super)
        @other_brand_user = create(:user, :brand)
        @evo_user = create(:user, :evo)
        @brand_super_user.confirm
        @ability = Ability.new(@brand_super_user)
      end
      context 'Startup abilities' do
        it { expect(@ability).to be_able_to(:create, Startup) }
        it { expect(@ability).to be_able_to(:index, Startup) }
        it { expect(@ability).to be_able_to(:profile, Startup) }
        it { expect(@ability).to be_able_to(:requests, Startup) }
        it { expect(@ability).not_to be_able_to(:questions, Startup) }
        it { expect(@ability).not_to be_able_to(:profile_activity, Startup) }
        it { expect(@ability).not_to be_able_to(:notes, Startup) }
        it { expect(@ability).to be_able_to(:watchlist, Startup) }
        it { expect(@ability).not_to be_able_to(:new_push_to_brand, Startup) }
        it { expect(@ability).not_to be_able_to(:push_to_brand, Startup) }
        it { expect(@ability).to be_able_to(:new_add_to_list, Startup) }
        it { expect(@ability).to be_able_to(:add_to_list, Startup) }
        it { expect(@ability).not_to be_able_to(:home, Startup) }
        it { expect(@ability).not_to be_able_to(:update, Startup) }
        it { expect(@ability).not_to be_able_to(:create, StartupProfileQuestion) }
        it { expect(@ability).not_to be_able_to(:index, StartupProfileQuestion) }
        #not being able to update question means that user cannot answer it
        it { expect(@ability).not_to be_able_to(:update, StartupProfileQuestion) }
      end
      context 'List abilities' do
        it { expect(@ability).to be_able_to(:create, List) }
        it { expect(@ability).to be_able_to(:add_to_favorites, List) }
        it { expect(@ability).to be_able_to(:read, List.new(author_id: @brand_super_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:destroy, List.new(author_id: @brand_super_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:destroy, List.new(author_id: @other_brand_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:destroy, List.new(author_id: @brand_super_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @other_brand_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @brand_super_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @brand_super_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:remove_from_favorites, List.new(author_id: @brand_super_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:remove_from_favorites, List.new(author_id: @other_brand_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:remove_from_favorites, List.new(author_id: @evo_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:update, List.new(author_id: @evo_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @evo_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @evo_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @other_brand_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:remove_from, List.new(author_id: @brand_super_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:remove_from, List.new(author_id: @other_brand_user.id, favorite: false)) }
      end
      context 'Tag abilities' do
        it { expect(@ability).to be_able_to(:create, Tag) }
        it { expect(@ability).to be_able_to(:read, Tag.new(team: 'brand')) }
        it { expect(@ability).to be_able_to(:destroy, Tag.new(team: 'brand')) }
      end
    end
    describe 'when is brand' do
      before(:each) do
        @brand_user = create(:user, :brand)
        @other_brand_user = create(:user, :brand_super)
        @evo_user = create(:user, :evo)
        @brand_user.confirm
        @ability = Ability.new(@brand_user)
      end
      context 'Startup abilities' do
        it { expect(@ability).to be_able_to(:create, Startup) }
        it { expect(@ability).to be_able_to(:index, Startup) }
        it { expect(@ability).to be_able_to(:profile, Startup) }
        it { expect(@ability).to be_able_to(:requests, Startup) }
        it { expect(@ability).not_to be_able_to(:questions, Startup) }
        it { expect(@ability).not_to be_able_to(:profile_activity, Startup) }
        it { expect(@ability).not_to be_able_to(:notes, Startup) }
        it { expect(@ability).to be_able_to(:watchlist, Startup) }
        it { expect(@ability).not_to be_able_to(:new_push_to_brand, Startup) }
        it { expect(@ability).not_to be_able_to(:push_to_brand, Startup) }
        it { expect(@ability).to be_able_to(:new_add_to_list, Startup) }
        it { expect(@ability).to be_able_to(:add_to_list, Startup) }
        it { expect(@ability).not_to be_able_to(:home, Startup) }
        it { expect(@ability).not_to be_able_to(:update, Startup) }
        it { expect(@ability).not_to be_able_to(:create, StartupProfileQuestion) }
        it { expect(@ability).not_to be_able_to(:index, StartupProfileQuestion) }
        #not being able to update question means that user cannot answer it
        it { expect(@ability).not_to be_able_to(:update, StartupProfileQuestion) }
      end
      context 'List abilities' do
        it { expect(@ability).to be_able_to(:create, List) }
        it { expect(@ability).to be_able_to(:add_to_favorites, List) }
        it { expect(@ability).to be_able_to(:destroy, List.new(author_id: @brand_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:read, List.new(author_id: @brand_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:destroy, List.new(author_id: @other_brand_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:destroy, List.new(author_id: @brand_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @other_brand_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @brand_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:update, List.new(author_id: @brand_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:remove_from_favorites, List.new(author_id: @brand_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:remove_from_favorites, List.new(author_id: @other_brand_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:remove_from_favorites, List.new(author_id: @evo_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:update, List.new(author_id: @evo_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @evo_user.id, favorite: false)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @evo_user.id, favorite: true)) }
        it { expect(@ability).not_to be_able_to(:read, List.new(author_id: @other_brand_user.id, favorite: true)) }
        it { expect(@ability).to be_able_to(:remove_from, List.new(author_id: @brand_user.id, favorite: false)) }
        it { expect(@ability).to be_able_to(:remove_from, List.new(author_id: @other_brand_user.id, favorite: false)) }
      end
      context 'Tag abilities' do
        it { expect(@ability).to be_able_to(:create, Tag) }
        it { expect(@ability).to be_able_to(:read, Tag.new(team: 'brand')) }
        it { expect(@ability).to be_able_to(:destroy, Tag.new(team: 'brand')) }
      end
    end
  end
end