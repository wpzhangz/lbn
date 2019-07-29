function GFunValue = localscore( LG, X, PAX )
%Input: X is the given variable, and PAX is the parents of X
%Output: GFunValue is the G function value given X and Parent(X)

GFunValue = 0;
N  = LG.CaseLength;
UsedSample = zeros(1,N);

DimX =  LG.VarRangeLength( X );
RangeX = LG.VarRange( X,: );
ri = DimX;
OriginalData = LG.VarSample;
d = 1 ;

if isempty(PAX)               %没有父节点时的得分
    GFunValue = gammaln( ri ) - gammaln( N + ri );
    for i= 1:ri
        count = hist(OriginalData(:,X),unique(OriginalData(:,X)));
        size(count);
        GFunValue = GFunValue + gammaln( count(i)+1 );
    end
else
    while  d <= N
        Frequency = zeros( 1,DimX );
        while d <= N && UsedSample( d ) == 1
            d = d + 1;
        end
        if d > N,break;end
        for t1 = 1:DimX
            if RangeX(t1) == OriginalData( d,X ), break; end
        end
        Frequency( t1 ) =  1;
        UsedSample( d )=1;
        ParentValue = OriginalData( d, PAX );
        d = d + 1;
        if d > N, break;end
        for k = d : N
            if UsedSample( k )==0
                if ParentValue == OriginalData( k, PAX )
                    t1 = 1;
                    while RangeX( t1 ) ~= OriginalData( k,X ),t1 = t1 + 1; end
                    Frequency( t1 ) = Frequency( t1 ) + 1;
                    UsedSample( k ) = 1;
                end
            end
        end
        Sum = sum( Frequency );
        for k = 1:ri
            if Frequency( k )~= 0
                GFunValue = GFunValue + gammaln( Frequency( k )+1 ); % Nijk is equal to Frequency( k )
            end
        end
        GFunValue = GFunValue + gammaln( ri ) - gammaln( Sum + ri ) ;
    end
end


%GFunValue
end


