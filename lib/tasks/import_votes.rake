
desc("Import votes from .txt file into database.")
task(import_votes: [:environment]) do

  votes_path = Rails.root.join('lib', 'assets', 'votes.txt')
  open_votes = File.open(votes_path)
  votes_rows = open_votes.readlines
  votes = 0

  valid_votes_path = Rails.root.join('lib', 'assets', 'valid_votes.csv')
  File.write(valid_votes_path, "Time,Campaign,Validity,Choice \n")
  valid_votes = 0

  invalid_votes_path = Rails.root.join('lib', 'assets', 'invalid_votes.csv')
  File.write(invalid_votes_path, "Time,Campaign,Validity,Choice,Error \n")
  invalid_votes = 0

  print("START - processing votes. \n")

  votes_rows.each do |vote_row|
    votes += 1

    selected_data = vote_row.force_encoding("iso-8859-1").split.values_at(1, 2, 3, 4)
    selected_data_extracted_values = selected_data[1..-1].map { |e| e.delete(' ').split(':')[1] }

    vote_time = selected_data[0]
    campaign_episode = selected_data_extracted_values[0]&.humanize
    validity_measure = selected_data_extracted_values[1]&.humanize
    choice_candidate = selected_data_extracted_values[2]&.humanize

    begin
      ActiveRecord::Base.transaction do
        campaign =
          Campaign
            .find_or_create_by!(
              episode: campaign_episode.humanize
            )

        candidate =
          Candidate
            .find_or_create_by!(
              name: choice_candidate.humanize
            )

        validity =
          Validity
            .find_or_create_by!(
              measure: validity_measure.humanize
            )

        candidate
          .votes
          .find_or_create_by!(
            external_identifier: vote_time,
            validity: validity
          )

        CampaignCandidate
          .find_or_create_by!(
            campaign: campaign,
            candidate: candidate
          )

        valid_votes += 1

        File.open(valid_votes_path, "a") { |file| file.write("#{vote_time},#{campaign_episode},#{validity_measure},#{choice_candidate} \n") }
      end

    rescue => error

      invalid_votes += 1

      File.open(invalid_votes_path, "a") { |file| file.write("#{vote_time},#{campaign_episode},#{validity_measure},#{choice_candidate},#{error} \n") }
    end
  end

  print("END - processing votes. \n")

  print("#{votes} votes were processed. \n")
  print("#{invalid_votes} votes were not imported because they were invalid: \n #{invalid_votes_path} \n")
  print("#{valid_votes} votes were imported because they were valid: \n #{valid_votes_path} \n")
end