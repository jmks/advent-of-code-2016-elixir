defmodule AoC.Day07Ipv7Test do
  use ExUnit.Case

  import AoC.Day07Ipv7
  alias AoC.Day07Ipv7.Ipv7

  test "supports_tls?" do
    assert supports_tls?("abba[mnop]qrst")
    refute supports_tls?("abcd[bddb]xyyx")
    refute supports_tls?("aaaa[qwer]tyui")
    assert supports_tls?("ioxxoj[asdfgh]zxcvbn")
    refute supports_tls?("ioxxoj[asdfgh]zxcvbn[abba]")
  end

  test "supports_ssl?" do
    assert supports_ssl?("aba[bab]xyz")
    refute supports_ssl?("xyx[xyx]xyx")
    assert supports_ssl?("aaa[kek]eke")
    assert supports_ssl?("zazbz[bzb]cdb")
  end
end
