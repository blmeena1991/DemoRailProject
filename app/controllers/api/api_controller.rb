class Api::ApiController < ApplicationController
  include PaginationStrongParams
  include GlobalErrorHandler
end