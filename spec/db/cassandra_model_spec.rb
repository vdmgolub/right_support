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
    @opt            = {}
    @instance = RightSupport::DB::CassandraModel.new(@key, {@offset => @value})

    @conn = flexmock(:conn)
    flexmock(Cassandra).should_receive(:new).with(@keyspace + "_" + @env,@server,@timeout).and_return(@conn)
    @conn.should_receive(:disable_node_auto_discovery!).and_return(true)
    @conn.should_receive(:insert).with(@column_family,@key, {@offset => @value},@opt).and_return(true)
    @conn.should_receive(:remove).with(@column_family,@key).and_return(true)
    @conn.should_receive(:get).with(@column_family)
    @conn.should_receive(:get_columns).and_return(true)
  end

  describe "instance\'s interface" do
     context :save do
      it 'saves a record using instance\'s interface' do
        @instance.save
      end
    end

    context :destroy do
      it 'destroys a record using instance\'s interface' do
        @instance.destroy
      end
    end
  end

  context :insert do
    it 'inserts a record by using the class method' do
      RightSupport::DB::CassandraModel.insert(@key, {@offset => @value},@opt).should be_true
    end
  end

  context :remove do
    it 'removes a record by using the class method' do
      RightSupport::DB::CassandraModel.remove(@key).should be_true
    end
  end

end