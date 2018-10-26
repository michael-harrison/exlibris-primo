module WebService
  module Request
    require 'test_helper'
    class ActionTest < Test::Unit::TestCase
      def setup
        @base_url = "http://bobcatdev.library.nyu.edu"
        @isbn = "0143039008"
        @user_id = "N12162279"
        @institution = "NYU"
        @doc_id = "nyu_aleph000062856"
        @dedupmgr_id = "dedupmrg17343091"
        @basket_id ="210075761"
        @new_folder_name = "new folder"
        @folder_to_remove = "377473116"
      end

      def test_eshelf_api_action
        assert_equal :get_eshelf_structure,
          Exlibris::Primo::WebService::Request::GetEshelfStructure.api_action
        assert_equal :get_eshelf,
          Exlibris::Primo::WebService::Request::GetEshelf.api_action
        assert_equal :add_to_eshelf,
          Exlibris::Primo::WebService::Request::AddToEshelf.api_action
        assert_equal :remove_from_eshelf,
          Exlibris::Primo::WebService::Request::RemoveFromEshelf.api_action
        assert_equal :add_folder_to_eshelf,
          Exlibris::Primo::WebService::Request::AddFolderToEshelf.api_action
        assert_equal :remove_folder_from_eshelf,
          Exlibris::Primo::WebService::Request::RemoveFolderFromEshelf.api_action
      end

      def test_call_eshelf_api_action
        assert_nothing_raised {
          VCR.use_cassette('request get eshelf structure') do
            Exlibris::Primo::WebService::Request::GetEshelfStructure.new(:base_url => @base_url,
              :institution => @institution, :user_id => @user_id).call
          end
          VCR.use_cassette('request get eshelf') do
            Exlibris::Primo::WebService::Request::GetEshelf.new(:base_url => @base_url,
              :institution => @institution, :user_id => @user_id, :folder_id => @basket_id).call
          end
          VCR.use_cassette('request add to eshelf') do
            Exlibris::Primo::WebService::Request::AddToEshelf.new(:base_url => @base_url,
              :institution => @institution, :user_id => @user_id, :doc_id => @doc_id, :folder_id => @basket_id).call
          end
          VCR.use_cassette('request remove from eshelf') do
            Exlibris::Primo::WebService::Request::RemoveFromEshelf.new(:base_url => @base_url,
              :institution => @institution, :user_id => @user_id, :doc_id => @doc_id, :folder_id => @basket_id).call
          end
          VCR.use_cassette('request add folder to eshelf') do
            Exlibris::Primo::WebService::Request::AddFolderToEshelf.new(:base_url => @base_url,
              :institution => @institution, :user_id => @user_id, :folder_name => @new_folder_name, :parent_folder => @basket_id).call
          end
          VCR.use_cassette('request remove folder from eshelf') do
            Exlibris::Primo::WebService::Request::RemoveFolderFromEshelf.new(:base_url => @base_url,
              :institution => @institution, :user_id => @user_id, :folder_id => @folder_to_remove).call
          end
        }
      end

      def test_search_api_action
        assert_equal :search_brief,
          Exlibris::Primo::WebService::Request::Search.api_action
        assert_equal :get_record,
          Exlibris::Primo::WebService::Request::FullView.api_action
      end

      def test_call_search_api_action
        assert_nothing_raised {
          VCR.use_cassette('request search isbn') do
            request = Exlibris::Primo::WebService::Request::Search.new(:base_url => @base_url, :institution => @institution)
            request.add_query_term @isbn, "isbn", "exact"
            request.call
          end
          VCR.use_cassette('request full view') do
            Exlibris::Primo::WebService::Request::FullView.new(:base_url => @base_url, :doc_id => @doc_id).call
          end
        }
      end

      def test_reviews_api_action
        assert_equal :get_reviews,
          Exlibris::Primo::WebService::Request::GetReviews.api_action
        assert_equal :get_all_my_reviews,
          Exlibris::Primo::WebService::Request::GetAllMyReviews.api_action
        assert_equal :get_reviews_for_record,
          Exlibris::Primo::WebService::Request::GetReviewsForRecord.api_action
        assert_equal :get_reviews_by_rating,
          Exlibris::Primo::WebService::Request::GetReviewsByRating.api_action
        assert_equal :add_review,
          Exlibris::Primo::WebService::Request::AddReview.api_action
        assert_equal :remove_review,
          Exlibris::Primo::WebService::Request::RemoveReview.api_action
      end

      def test_tags_api_action
        assert_equal :get_tags,
          Exlibris::Primo::WebService::Request::GetTags.api_action
        assert_equal :get_all_my_tags,
          Exlibris::Primo::WebService::Request::GetAllMyTags.api_action
        assert_equal :get_tags_for_record,
          Exlibris::Primo::WebService::Request::GetTagsForRecord.api_action
        assert_equal :remove_tag,
          Exlibris::Primo::WebService::Request::RemoveTag.api_action
        assert_equal :remove_user_tags,
          Exlibris::Primo::WebService::Request::RemoveUserTags.api_action
      end

      def test_undefined_action
        Exlibris::Primo::WebService::Request::Search.send(:api_action=, :undefined_action)
        assert_raise(NoMethodError) {
          VCR.use_cassette('request undefined action call') do
            Exlibris::Primo::WebService::Request::Search.new(:base_url => @base_url).call
          end
        }
        Exlibris::Primo::WebService::Request::Search.send(:api_action=, :search_brief)
      end
    end
  end
end