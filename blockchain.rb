require 'digest'

class Blockchain 
  attr_accessor :chain

  def initialize()
    @chain = []
    create_block(1, "0")
  end

  def create_block(proof, previous_hash)
    block = {
      index: chain.length(),
      timestamp: Time.now.to_s,
      previous_hash: previous_hash,
      proof: proof
    }

    @chain.push(block)

    return block
  end

  def get_previous_block
    return @chain.last()
  end

  def proof_of_work(previous_proof)
    new_proof = 1
    check_proof = false

    while check_proof == false do
      bet = ((new_proof.to_i**2) - (previous_proof.to_i**2)).to_s;

      hash_operation = Digest::SHA256.hexdigest(bet)

      puts ("[MINE] PROOF: #{new_proof} | HASH: #{hash_operation}")

      if (hash_operation.slice(0, 4) == '0000')
        check_proof = true
      else
        new_proof += 1
      end
    end

    return new_proof
  end

  def hash(block)
    return Digest::SHA256.hexdigest(block.to_s)
  end

  def is_chain_valid
    previous_block = @chain[0]
    next_block_idx = 1

    while next_block_idx < @chain.length() do
      block = @chain[next_block_idx]

      if block.previous_hash != hash(previous_block)
        return false
      end

      previous_proof = previous_block.proof
      current_proof = block.proof
      test = ((current_proof.to_i**2) - (previous_proof.to_i**2)).to_s

      hash_operation = Digest::SHA256.hexdigest(test)

      if hash_operation.slice(0, 4) != '0000'
        return false
      end

      previous_block = block
      next_block_idx += 1
    end

    return true
  end
end
