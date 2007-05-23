module WillPaginate
  module ViewHelpers
    # Renders Digg-style pagination. (We know you wanna!)
    # Returns nil if there is only one page in total (can't paginate that).
    #
    def will_paginate entries = @entries, options = {}
      total_pages = entries.page_count

      if total_pages > 1
        page = entries.current_page
        options = options.symbolize_keys.reverse_merge :class => 'pagination',
          :prev_label   => '&laquo; Previous',
          :next_label   => 'Next &raquo;',
          :inner_window => 4, # links around the current page
          :outer_window => 1  # links around beginning and end
        
        inner_window, outer_window = options.delete(:inner_window).to_i, options.delete(:outer_window).to_i
        min = page - inner_window
        max = page + inner_window
        
        # adjust lower or upper limit if other is out of bounds
        if max > total_pages then min -= max - total_pages
        elsif min < 1  then max += 1 - min
        end
        
        current   = min..max
        beginning = 1..(1 + outer_window)
        tail      = (total_pages - outer_window)..total_pages
        visible   = [current, beginning, tail].map(&:to_a).sum
        
        # build the list of the links
        links = (1..total_pages).inject([]) do |list, n|
          if visible.include? n
            list << link_or_span(n, n == page, 'current')
          elsif n == beginning.last + 1 || n == tail.first - 1
            # ellipsis represents the gap between windows
            list << '...'
          end
          list
        end
        
        # next and previous buttons
        prev, succ  = page - 1, page + 1
        links.unshift link_or_span(prev, prev.zero?,         'disabled', options.delete(:prev_label))
        links.push    link_or_span(succ, succ > total_pages, 'disabled', options.delete(:next_label))
        
        content_tag :div, links.join, options
      end
    end
    
  protected

    def link_or_span(page, condition_for_span, span_class = nil, text = page.to_s)
      if condition_for_span
        content_tag :span, text, :class => span_class
      else
        # page links should preserve GET parameters, so we merge params
        link_to text, params.merge(:page => (page !=1 ? page : nil))
      end
    end
  end
end
