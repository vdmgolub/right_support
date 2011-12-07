require 'spec_helper'

describe RightSupport::DB::CassandraModel do
  class Cassandra;end

  def init_app_state(column_family,keyspace,server,env)
    ENV["RACK_ENV"] = env
    RightSupport::DB::CassandraModel.column_family = column_family
    RightSupport::DB::CassandraModel.keyspace = keyspace
    RightSupport::DB::CassandraModel.config = {"test" => {"server" => server}}
  end

  before(:all) do
    @column_family  = "TestApp"
    @keyspace       = "TestAppService"
    @server         = "localhost:9160"
    @env            = "test"
    @timeout        = {:timeout => RightSupport::DB::CassandraModel::DEFAULT_TIMEOUT}

    init_app_state(@column_family,@keyspace,@server,@env)

    @key            = 'key'
    @value          = 'foo'
    @offset         = 'bar'
    
    @conn = flexmock(:conn)
    flexmock(Cassandra).should_receive(:new).with(@keyspace + "_" + @env,@server,@timeout).and_return(@conn)
    @conn.should_receive(:disable_node_auto_discovery!).and_return(true)
    @conn.should_receive(:insert).with(@column_family,@keyspace,@key, {@offset => @value}).and_return(true)
    @conn.should_receive(:remove).with(@column_family,@keyspace,@key).and_return(true)
    @conn.should_receive(:get_columns).and_return(true)
  end

  context :save do
    it 'inserts a record' do
      RightSupport::DB::CassandraModel.insert(@keyspace, @key, {@offset => @value}).should be_true
    end
  end

  context :destroy do
    it 'removes a record' do
      RightSupport::DB::CassandraModel.remove(@keyspace, @key).should be_true
    end
  end

end