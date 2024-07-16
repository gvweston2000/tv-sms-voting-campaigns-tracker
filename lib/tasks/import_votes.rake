
desc("Import votes from .txt file into database.")
task(import_votes: [:environment]) do

  votes_path = Rails.root.join('lib', 'assets', 'votes.txt')
  open_votes = File.open(votes_path)
  votes_rows = open_votes.readlines

  invalid_votes_path = Rails.root.join('lib', 'assets', 'invalid_votes.csv')
  File.write(invalid_votes_path, "Time,Campaign,Validiity,Choice \n")

  valid_votes_path = Rails.root.join('lib', 'assets', 'valid_votes.csv')
  File.write(valid_votes_path, "Time,Campaign,Validiity,Choice \n")

  votes_rows.each do |vote_row|
    selected_data = vote_row.force_encoding("iso-8859-1").split.values_at(1, 2, 3, 4)

    selected_data_extracted_values = selected_data[1..-1].map { |e| e.delete(' ').split(':')[1] }

    vote_time = selected_data[0]
    campaign_episode = selected_data_extracted_values[0]
    validity_measure = selected_data_extracted_values[1]
    choice_candidate = selected_data_extracted_values[2]

    valid_time = valid_time.present? 
    valid_episode = campaign_episode.present?
    valid_measure = validity_measure.present? && %[pre during post].include?(validity_measure)
    valid_candidate = choice_candidate.present? && choice_candidate.count("a-zA-Z") > 0

    unless (valid_time || valid_episode || valid_measure || valid_candidate)
      File.open(invalid_votes_path, "a") { |file| file.write("#{vote_time},#{campaign_episode},#{validity_measure},#{choice_candidate} \n") }
      next
    else
      File.open(valid_votes_path, "a") { |file| file.write("#{vote_time},#{campaign_episode},#{validity_measure},#{choice_candidate} \n") }
    end

    campaign =
      Campaign
        .find_or_create_by!(
          episode: campaign_episode
        )

    candidate =
      campaign
        .candidates
        .find_or_create_by!(
          name: choice_candidate.humanize
        )

    validity =
      Validity
        .find_or_create_by!(
          measure: validity_measure
        )

    candidate
      .votes
      .find_or_create_by!(
        external_identifier: vote_time,
        validity: validity
      )
    
  end
end