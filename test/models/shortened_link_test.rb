require 'test_helper'

class ShortenedLinkTest < ActiveSupport::TestCase
  test "valid record" do
    shortened_link = ShortenedLink.new(name: 'Google', original_url: 'http://google.com', unique_key: 'abef1', shortened_url: 'http://localhost/s/abef1', hit_count: 0)
    assert shortened_link.valid?
  end

  test "invalid without name" do
    shortened_link = ShortenedLink.new(original_url: 'http://google.com', unique_key: 'abef1', shortened_url: 'http://localhost/s/abef1', hit_count: 0)
    refute shortened_link.valid?
    assert_not_nil shortened_link.errors[:name]
  end

  test "invalid without original url" do
    shortened_link = ShortenedLink.new(name: 'Google', unique_key: 'abef1', shortened_url: 'http://localhost/s/abef1', hit_count: 0)
    refute shortened_link.valid?
    assert_not_nil shortened_link.errors[:original_url]
  end

  test "invalid without unique_key" do
    shortened_link = ShortenedLink.new(name: 'Google', original_url: 'http://google.com', shortened_url: 'http://localhost/s/abef1', hit_count: 0)
    refute shortened_link.valid?
    assert_not_nil shortened_link.errors[:unique_key]
  end

  test "invalid without shortened_url" do
    shortened_link = ShortenedLink.new(name: 'Google', original_url: 'http://google.com', unique_key: 'abef1', hit_count: 0)
    refute shortened_link.valid?
    assert_not_nil shortened_link.errors[:shortened_url]
  end

  test "valid without hit_count" do
    shortened_link = ShortenedLink.new(name: 'Google', original_url: 'http://google.com', unique_key: 'abef1', shortened_url: 'http://localhost/s/abef1')
    assert shortened_link.valid?
  end

  test "default hit_count set to 0" do
    shortened_link = ShortenedLink.create(name: 'Google', original_url: 'http://google.com', unique_key: 'abef1', shortened_url: 'http://localhost/s/abef1')
    assert shortened_link.hit_count == 0
  end
end