require 'sinatra'
require_relative 'blockchain'

blockchain = Blockchain.new

get '/' do
  'Trinda Blockchain'
end

get '/mine_block' do
  previous_block = blockchain.get_previous_block()
  previous_proof = previous_block['proof']
  previous_hash = blockchain.hash(previous_block)
  proof = blockchain.proof_of_work(previous_proof)

  block = blockchain.create_block(proof, previous_hash)

  return block.to_json
end

get '/get_chain' do
  return {
    length: blockchain.chain.length(),
    chain: blockchain.chain
  }.to_json
end

get '/date' do
  time = Time.now

  data = {
    message: 'Data atual',
    data: time.strftime("%d/%m/%Y %H:%M")
  }

  return data.to_json
end
