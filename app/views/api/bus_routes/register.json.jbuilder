json.success @result
json.company_id @company.try(:id)
json.line_id @line.try(:id)