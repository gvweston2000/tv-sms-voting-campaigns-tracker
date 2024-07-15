
desc("Import votes from .txt file into database.")
task(import_votes: [:environment]) do

  path = Rails.root.join('lib', 'assets', 'votes.txt')
  file = File.open(path)
  rows = file.readlines

  row_number = 0

  rows.each do |row|
    row_number += 1

    selected_data = row.force_encoding("iso-8859-1").split.values_at(1, 2, 3, 4)

    selected_data_extracted_values = selected_data[1..-1].map { |e| e.split(':')[1] }

    aggregated_vote_row = 
      {
        vote_external_identifier: selected_data[0],
        campaign_episode: selected_data_extracted_values[0],
        validity_measure: selected_data_extracted_values[1],
        choice_candidate: selected_data_extracted_values[2]
      }

    campaign =
      Campaign
        .find_or_create_by!(
          episode: aggregated_vote_row[:campaign_episode]
        )

    candidate =
      campaign
        .candidates
        .find_or_create_by!(
          name: aggregated_vote_row[:choice_candidate]
        )

    validity =
      Validity
        .find_or_create_by!(
          measure: aggregated_vote_row[:validity_measure]
        )

    candidate
      .votes
      .find_or_create_by!(
        external_identifier: aggregated_vote_row[:vote_external_identifier],
        validity: validity
      )
    
  end
end