class Protocol

  def main

    o = op input

    o.input.all.take
    o.output.all.produce

    show {
      title "Protocol information"
      note "This protocol is used to take cytometer readings from deepwell plates using u-bottom plates."
    }

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
