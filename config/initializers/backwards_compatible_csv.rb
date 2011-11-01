require "csv"
if CSV.const_defined? :Reader #If we're using the old version of CSV
  CSV = FasterCSV #actually use the new version.
end
