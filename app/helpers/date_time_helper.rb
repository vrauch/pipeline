module DateTimeHelper

  def year_months
    @dates_range ||= []
    return @dates_range if @dates_range.any?
    time_start = Startup::MONTHS_INTERVAL.months.ago
    time_end = 0.seconds.ago
    time = time_start
    while time <= time_end
      @dates_range << DateTime.new(time.year, time.month).strftime('%b’ %y')
      time = time.next_month
    end
    @dates_range
  end

end